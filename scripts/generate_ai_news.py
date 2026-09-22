import os
import json
import urllib.request
import re
from datetime import datetime

# 1. Configuration
API_KEY = os.environ.get('GEMINI_API_KEY')
if not API_KEY:
    raise ValueError("GEMINI_API_KEY environment variable is required. Please set it in GitHub Secrets.")

DART_FILE_PATH = os.path.join(os.path.dirname(__file__), '..', 'lib', 'features', 'content', 'data', 'generated_ai_posts.dart')
SITEMAP_PATH = os.path.join(os.path.dirname(__file__), '..', 'web', 'sitemap.xml')

TOPICS_ROTATION = [
    "Cursor AI & Agentic Developer Workflows: How autonomous coding environments are replacing traditional IDEs",
    "DeepSeek-V3 & Open Weights Revolution: Architectures, Mixture of Experts, and Cost-per-Token Economics",
    "Claude 3.7 Sonnet and the Emergence of Hybrid Reasoning Models: System 1 vs System 2 Thinking in LLMs",
    "Local On-Device AI with Llama 3 & Ollama: Running 70B Quantized Models on Mobile and Edge Hardware",
    "Autonomous Multi-Agent Swarms: Architecting CrewAI, LangGraph, and AutoGen for Real-World Production Systems",
    "AI-Augmented Healthcare & Clinical Telemetry: Transforming Health IT Diagnostics with Local LLM Privacy",
    "The Evolution of Flutter & Mobile AI: Integrating On-Device Tensor Neural Processing Units in Dart Apps",
    "Model Context Protocol (MCP): How Anthropic's Open Standard is Unifying Tools, APIs, and AI Agent Context",
    "DeepSeek-R1 vs OpenAI o1 & o3: Chain of Thought Reasoning Benchmarks and Verification Architectures",
    "Vector Databases & Hybrid Search: Scaling SQLite FTS5 with Semantic Embeddings for Real-time App Retrieval",
]

def load_existing_posts():
    """Extract existing posts from the Dart file if it exists."""
    posts = []
    if os.path.exists(DART_FILE_PATH):
        try:
            with open(DART_FILE_PATH, 'r', encoding='utf-8') as f:
                content = f.read()
            # Find embedded JSON or parse existing slugs
            existing_slugs = re.findall(r"slug:\s*'([^']+)'", content)
            return existing_slugs
        except Exception as e:
            print(f"Error reading existing posts: {e}")
    return posts

def generate_article_with_gemini(existing_slugs):
    """Call Google Gemini API to generate an authoritative, captivating AI tech article."""
    # Pick a topic that hasn't been recently covered
    selected_topic = TOPICS_ROTATION[0]
    for topic in TOPICS_ROTATION:
        simplified = re.sub(r'[^a-zA-Z0-9]', '', topic.lower())
        matched = any(simplified in s.replace('-', '').lower() for s in existing_slugs)
        if not matched:
            selected_topic = topic
            break

    now = datetime.now()
    current_date = now.strftime("%B %Y")
    post_id = f"post-ai-{int(now.timestamp())}"

    prompt = f"""
You are an elite AI researcher and software architect writing an authoritative, captivating technical dispatch for Bibek Bhattarai's technology journal.
The article should be compelling, technical, data-driven, and attractive to software engineers, CTOs, and AI enthusiasts.

TOPIC: {selected_topic}

Return ONLY a valid JSON object with the following schema:
{{
  "id": "{post_id}",
  "title": "A captivating, high-impact headline",
  "slug": "url-friendly-slug-lowercase",
  "category": "AI & Technology",
  "date": "{current_date}",
  "readTime": "7 min read",
  "isFeatured": true,
  "statisticsHeadline": "DATA-DRIVEN HEADLINE IN CAPS • STATISTICAL BREAKDOWN",
  "sampleMetric": "Concrete quantitative metric (e.g. 3.2x throughput • 78% latency reduction)",
  "newsImageUrl": "assets/images/products/app_feature_graphic.png",
  "tags": ["AI", "Developer Tools", "Machine Learning", "Software Architecture"],
  "excerpt": "A punchy, compelling 2-sentence summary highlighting the core technological shift.",
  "contentMarkdown": "Comprehensive technical markdown article (at least 500 words). Include:
# Title
### Architectural Overview
Detailed explanation of how it works under the hood.
### Quantitative Benchmarks & Key Metrics
A markdown comparison table or performance breakdown.
### Code Snippet & Implementation
A concrete, runnable code example (Dart/Flutter, Python, or TypeScript).
### Critical Analysis: Trade-offs & Production Realities
Pros and cons, security implications, edge cases.
### The Engineering Verdict
Concluding forward-looking takeaway."
}}

Do not wrap in markdown ```json fences. Output raw JSON only.
"""

    models_to_try = [
        'gemini-3-flash-preview',
        'gemini-3.1-flash-lite',
        'gemini-3.5-flash',
        'gemini-flash-latest'
    ]
    last_error = None

    for model in models_to_try:
        for attempt in range(3):
            url = f"https://generativelanguage.googleapis.com/v1beta/models/{model}:generateContent?key={API_KEY}"
            req_data = json.dumps({
                'contents': [{'parts': [{'text': prompt}]}],
                'generationConfig': {
                    'responseMimeType': 'application/json',
                    'temperature': 0.7,
                }
            }).encode('utf-8')

            req = urllib.request.Request(url, data=req_data, headers={'Content-Type': 'application/json'})
            try:
                print(f"Attempting generation with {model} (attempt {attempt + 1})...")
                with urllib.request.urlopen(req, timeout=45) as response:
                    res = json.loads(response.read().decode('utf-8'))
                    raw_json = res['candidates'][0]['content']['parts'][0]['text'].strip()
                    if raw_json.startswith('```json'):
                        raw_json = raw_json[7:]
                    if raw_json.startswith('```'):
                        raw_json = raw_json[3:]
                    if raw_json.endswith('```'):
                        raw_json = raw_json[:-3]
                    article_data = json.loads(raw_json.strip())
                    print(f"Generated successfully using model {model}!")
                    return article_data
            except Exception as e:
                print(f"Model {model} attempt {attempt + 1} failed: {e}")
                last_error = e
                import time
                time.sleep(4)

    raise Exception(f"All models failed: {last_error}")

def serialize_dart_post(p):
    """Serialize an article dict to a Dart JournalPost literal."""
    tags_str = ", ".join([f"'{t}'" for t in p.get('tags', [])])
    # Escape single quotes and dollar signs in markdown for raw string
    md = p.get('contentMarkdown', '').replace("'''", r"\'\'\'")
    
    return f"""  JournalPost(
    id: '{p.get("id")}',
    title: {json.dumps(p.get("title"))},
    slug: '{p.get("slug")}',
    category: '{p.get("category", "AI & Technology")}',
    date: '{p.get("date")}',
    readTime: '{p.get("readTime", "6 min read")}',
    isFeatured: {str(p.get("isFeatured", True)).lower()},
    statisticsHeadline: {json.dumps(p.get("statisticsHeadline", ""))},
    sampleMetric: {json.dumps(p.get("sampleMetric", ""))},
    newsImageUrl: '{p.get("newsImageUrl", "assets/images/products/app_feature_graphic.png")}',
    tags: const [{tags_str}],
    excerpt: {json.dumps(p.get("excerpt", ""))},
    contentMarkdown: r'''
{md}
''',
  ),"""

def save_dart_file(new_post):
    """Prepend the new post into generated_ai_posts.dart."""
    existing_posts_code = ""
    if os.path.exists(DART_FILE_PATH):
        try:
            with open(DART_FILE_PATH, 'r', encoding='utf-8') as f:
                code = f.read()
                # Extract between `[` and `];`
                start = code.find('List<JournalPost> generatedAiPosts = [')
                if start != -1:
                    bracket_start = code.find('[', start)
                    bracket_end = code.rfind('];')
                    if bracket_start != -1 and bracket_end != -1:
                        existing_posts_code = code[bracket_start + 1:bracket_end].strip()
        except Exception as e:
            print(f"Error reading existing Dart file: {e}")

    # Build new Dart file content
    dart_code = f"""import '../domain/models/journal_post.dart';

/// Automatically generated by Gemini AI scheduled workflow.
/// Updates twice daily with trending AI breakthroughs, benchmarks, and tools.
final List<JournalPost> generatedAiPosts = [
{serialize_dart_post(new_post)}
{existing_posts_code}
];
"""
    # Clean up empty lines
    dart_code = re.sub(r'\n{3,}', '\n\n', dart_code)
    
    os.makedirs(os.path.dirname(DART_FILE_PATH), exist_ok=True)
    with open(DART_FILE_PATH, 'w', encoding='utf-8') as f:
        f.write(dart_code)
    print(f"Saved new post '{new_post.get('title')}' to {DART_FILE_PATH}")

def update_sitemap(new_post):
    """Add new article URL to sitemap.xml for instant Google indexing."""
    if not os.path.exists(SITEMAP_PATH):
        return

    today = datetime.now().strftime("%Y-%m-%d")
    slug = new_post.get('slug')
    
    try:
        with open(SITEMAP_PATH, 'r', encoding='utf-8') as f:
            content = f.read()

        # Check if already present
        if slug in content:
            return

        new_entry = f"""  <url>
    <loc>https://www.bhattaraibvk.com.np/blog/{slug}</loc>
    <lastmod>{today}</lastmod>
    <changefreq>daily</changefreq>
    <priority>0.9</priority>
  </url>
</urlset>"""

        content = content.replace("</urlset>", new_entry)
        with open(SITEMAP_PATH, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"Added https://www.bhattaraibvk.com.np/blog/{slug} to sitemap.xml")
    except Exception as e:
        print(f"Error updating sitemap: {e}")

def main():
    print(f"Starting Gemini AI Daily News Generator at {datetime.now()}...")
    existing_slugs = load_existing_posts()
    print(f"Found {len(existing_slugs)} existing AI posts.")
    
    new_post = generate_article_with_gemini(existing_slugs)
    save_dart_file(new_post)
    update_sitemap(new_post)
    print("AI News generation complete!")

if __name__ == '__main__':
    main()
