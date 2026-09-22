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
    "MiniMax Video-01 vs HeyGen: The Free Open-Architecture AI Video Revolution Disrupting Generative Avatars",
    "Top 7 Free GitHub AI Repositories You Must Clone: Self-Hosting vLLM, Ollama, ComfyUI, and Dify",
    "Cursor AI & Agentic Developer Workflows: How Autonomous Free & Open Repositories Outpace Closed IDEs",
    "DeepSeek-R1 & Open-Weights Reasoning: Running Distilled Zero-Cost Reasoning Models Locally with Ollama",
    "Kokoro & ChatTTS Open Audio: Ultra-Realistic Free Local Voice Synthesis Replacing Commercial TTS APIs",
    "Wan2.1 & CogVideoX: Running Cinematic 1080p AI Video Generation Locally on Consumer GPUs",
    "OpenWebUI & Local AI Hubs: Self-Hosting an Enterprise-Grade ChatGPT Alternative for Free on GitHub",
    "Claude 3.7 & Agentic Coding: Structuring Free Context-Aware Swarms with Model Context Protocol (MCP)",
    "ComfyUI Mastery for AI Artists: Essential Free Custom Nodes and Workflows Trending on GitHub",
    "FastAI & vLLM High-Throughput Inference: Slashing Token Latency by 70% with Zero Cloud Lock-in",
]

# Curated High-Resolution Royalty-Free Tech & AI Photography for News Dispatches
CURATED_NEWS_PHOTOS = [
    "https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?auto=format&fit=crop&w=1200&q=80",  # Neural Network Abstract
    "https://images.unsplash.com/photo-1677442136019-21780efad99a?auto=format&fit=crop&w=1200&q=80",  # AI Intelligence
    "https://images.unsplash.com/photo-1555066931-4365d14bab8c?auto=format&fit=crop&w=1200&q=80",  # Coding & Terminal
    "https://images.unsplash.com/photo-1535378620166-273708d44e4c?auto=format&fit=crop&w=1200&q=80",  # Generative AI Media
    "https://images.unsplash.com/photo-1620712943543-bcc4688e7485?auto=format&fit=crop&w=1200&q=80",  # Deep Learning Mesh
    "https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=1200&q=80",  # GPU Chips & Hardware
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
    selected_idx = 0
    for idx, topic in enumerate(TOPICS_ROTATION):
        simplified = re.sub(r'[^a-zA-Z0-9]', '', topic.lower())
        matched = any(simplified in s.replace('-', '').lower() for s in existing_slugs)
        if not matched:
            selected_topic = topic
            selected_idx = idx
            break

    now = datetime.now()
    current_date = now.strftime("%B %Y")
    post_id = f"post-ai-{int(now.timestamp())}"
    suggested_photo = CURATED_NEWS_PHOTOS[selected_idx % len(CURATED_NEWS_PHOTOS)]

    prompt = f"""
You are an elite AI researcher, viral tech journalist, and open-source software architect writing an authoritative, captivating technical dispatch for Bibek Bhattarai's technology and AI news platform.
The article must be engaging, data-driven, viral, and highly practical for software engineers, founders, and AI enthusiasts. It must spotlight practical tools, free GitHub repositories, and quantitative comparisons (e.g. inference speed, memory footprint, licensing).

TOPIC: {selected_topic}

Return ONLY a valid JSON object with the following schema:
{{
  "id": "{post_id}",
  "title": "A high-impact, captivating headline that attracts organic search traffic and developers",
  "slug": "url-friendly-slug-lowercase",
  "category": "AI & Technology",
  "date": "{current_date}",
  "readTime": "6 min read",
  "isFeatured": true,
  "statisticsHeadline": "DATA-DRIVEN HEADLINE IN CAPS • QUANTITATIVE BENCHMARKS",
  "sampleMetric": "Concrete quantitative metric (e.g. 100% Free & Open-Source • 4.8x Faster Inference • Apache 2.0)",
  "newsImageUrl": "{suggested_photo}",
  "tags": ["AI Tools", "Free AI", "GitHub", "Open Source", "Machine Learning"],
  "excerpt": "A punchy, viral 2-sentence summary highlighting why this tool or repository is taking over developer communities.",
  "contentMarkdown": "Comprehensive technical markdown article (at least 600 words). Include:
# Title
### Why This AI Tool / Repository is Going Viral
Explain the core breakthrough, why developers are switching to it, and how it compares to expensive closed alternatives (e.g. HeyGen, OpenAI, Runway).
### Architectural Breakdown & Core Mechanics
Detailed technical look at how the underlying weights, model architecture, or pipeline functions.
### Quantitative Benchmarks & Comparison Matrix
A markdown comparison table highlighting performance, VRAM usage, inference speed, and pricing/licensing.
### Quickstart & Code Implementation
A concrete, copy-pasteable terminal command, Python script, or Docker run snippet to get started in under 60 seconds.
### The Open-Source Verdict & Roadmap
Concluding actionable recommendation for developers and architects."
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
