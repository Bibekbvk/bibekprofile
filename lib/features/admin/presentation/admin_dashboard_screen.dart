import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/url_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../content/data/mock_content_repository.dart';
import '../../content/domain/models/journal_post.dart';
import '../../portfolio/presentation/portfolio_provider.dart';
import '../domain/models/analytics_model.dart';

/// Full-featured Executive Administration Dashboard for managing AI news automation,
/// reviewing contact inquiries, and publishing custom articles.
class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedTab = 0; // 0: AI News Engine, 1: Inquiries Inbox, 2: Infrastructure

  // Composer Form controllers
  final _composerFormKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _excerptController = TextEditingController();
  final _contentController = TextEditingController();
  final _tagsController = TextEditingController();
  final _imageUrlController = TextEditingController(
    text: 'https://images.unsplash.com/photo-1535378620166-273708d44e4c?auto=format&fit=crop&w=1200&q=80',
  );
  String _selectedCategory = 'AI & Technology';
  String _readTime = '6 min read';
  bool _isComposerExpanded = false;
  int _selectedViralTopicIndex = 0;

  static final List<Map<String, dynamic>> _viralPresets = [
    {
      'name': 'MiniMax Video-01 vs HeyGen (Free AI Video)',
      'title': 'MiniMax Video-01 vs HeyGen: How Free Open AI Video Engines Outpace Commercial Subscriptions',
      'category': 'AI & Technology',
      'readTime': '6 min read',
      'imageUrl': 'https://images.unsplash.com/photo-1535378620166-273708d44e4c?auto=format&fit=crop&w=1200&q=80',
      'tags': 'MiniMax, HeyGen, AI Video, Free AI Tools, Open Source Video',
      'excerpt': 'With MiniMax Video-01 and Wan2.1 hitting open releases, developers and creators are achieving 1080p cinematic video and avatar synthesis without paying \$30+/mo commercial licensing.',
      'metric': '100% Free Open Weights • 25 FPS Native • Zero Cloud Lock-In',
      'content': r'''# MiniMax Video-01 vs HeyGen: How Free Open AI Video Engines Outpace Commercial Subscriptions

### The Paradigm Shift in Generative Video
For the past two years, creators and marketing teams relied on closed platforms like HeyGen and Runway, spending hundreds of dollars monthly on restrictive credit quotas and cloud rendering queues.

The launch of **MiniMax Video-01**, alongside **Wan 2.1** and **CogVideoX**, has completely inverted this dynamic. By distributing open-weights foundation models capable of direct text-to-video, image-to-video, and avatar speech synchronization, the barrier to high-fidelity synthetic media has collapsed to zero.

---

### Comparative Architecture & Benchmarks

| Feature / Model | HeyGen (Commercial SaaS) | MiniMax Video-01 (Open Weights) | Wan 2.1 (Open Source) |
| :--- | :--- | :--- | :--- |
| **Licensing** | Paid Subscription | Open Community API / Weights | Apache 2.0 |
| **Resolution** | Up to 1080p / 4K | 1280x720 & 1080p Native | 1080p Ultra-HD |
| **Frame Consistency** | High | Very High (Diffusion Transformer) | State-of-the-Art DiT |
| **Local Inference** | No (Cloud Only) | Supported (FP8 / INT4 VRAM) | Supported (Consumer 16GB GPU) |
| **Cost Per Render** | \$1.00 – \$3.00/min | \$0.00 (Self-Hosted) | \$0.00 (Local Hardware) |

---

### Quickstart: Running MiniMax Inference in Python

```python
import requests

# Example interacting with local or self-hosted MiniMax Video endpoint
endpoint = "http://localhost:8000/v1/video/generations"
payload = {
    "prompt": "Cinematic slow pan across modern server room, neon lighting, 8k resolution photorealistic",
    "resolution": "1080p",
    "duration_seconds": 6
}
response = requests.post(endpoint, json=payload)
print("Rendering Job Initiated:", response.json()["task_id"])
```

---

### Key Takeaways for Developers
- Open-weights models now match or exceed proprietary video quality.
- Integrating these pipelines into automated marketing bots and video synthesis backends saves thousands in SaaS overhead.
- Watch GitHub for community ComfyUI wrappers that package these models for one-click desktop generation.''',
    },
    {
      'name': 'Top 7 Free GitHub AI Repos (vLLM, Ollama, Dify)',
      'title': 'Top 7 Free GitHub AI Repositories You Should Clone This Week for Zero-Cost Intelligence',
      'category': 'AI & Technology',
      'readTime': '7 min read',
      'imageUrl': 'https://images.unsplash.com/photo-1555066931-4365d14bab8c?auto=format&fit=crop&w=1200&q=80',
      'tags': 'GitHub, Open Source, vLLM, Ollama, Dify, ComfyUI, DeepSeek',
      'excerpt': 'From blazing-fast vLLM PagedAttention serving to zero-setup local Ollama reasoning and Dify agent workflows, these open-source GitHub repositories replace tens of paid cloud tools.',
      'metric': '100% Open Source • 350K+ GitHub Stars Combined • Apache / MIT',
      'content': r'''# Top 7 Free GitHub AI Repositories You Should Clone This Week for Zero-Cost Intelligence

### The Open Source AI Explosion on GitHub
The era of paying monthly subscriptions for basic LLM chat interfaces, embedding stores, and API wrappers is officially over. The open-source community on GitHub has engineered battle-tested alternatives that run natively on consumer hardware and self-hosted cloud instances.

Here are the top repositories delivering maximum leverage in 2026:

---

### 1. vLLM (vllm-project/vllm)
- **What it is**: High-throughput and memory-efficient LLM serving engine.
- **Why it matters**: Uses **PagedAttention** to eliminate VRAM fragmentation, delivering **2x–4x higher throughput** than standard HuggingFace pipelines.

### 2. Ollama (ollama/ollama)
- **What it is**: One-line command CLI for running Llama 3, DeepSeek-R1, and Mistral models locally.
- **Why it matters**: Zero-configuration quantization and cross-platform GPU acceleration (macOS Metal, Windows CUDA, Linux ROCm).

### 3. Dify (langgenius/dify)
- **What it is**: Open-source LLM app development and visual multi-agent workflow platform.
- **Why it matters**: Replaces complex LangChain scripts with an intuitive visual canvas for RAG and autonomous tool execution.

### 4. ComfyUI (comfyanonymous/ComfyUI)
- **What it is**: Node-based graph architecture for generative image, video, and audio synthesis.
- **Why it matters**: Surgical control over diffusion latents, ControlNet weights, and LoRA stacking.

### 5. Kokoro-82M (hexgrad/kokoro)
- **What it is**: Ultra-lightweight 82M parameter text-to-speech model.
- **Why it matters**: Delivers ElevenLabs-quality voice synthesis in real time with a tiny footprint.

---

### Implementation: Quick Terminal Setup

```bash
# 1. Spin up high-speed local inference with Ollama
curl -fsSL https://ollama.com/install.sh | sh
ollama run deepseek-r1:8b

# 2. Deploy vLLM server with OpenAI-compatible API
pip install vllm
python -m vllm.entrypoints.openai.api_server --model meta-llama/Meta-Llama-3-8B-Instruct
```

---

### Architectural Conclusion
Self-hosting these repositories gives you complete data privacy, zero API rate limits, and zero recurring cloud costs.''',
    },
    {
      'name': 'Cursor AI & Claude 3.7 Free Agentic Swarms',
      'title': 'Autonomous Agentic Coding with Cursor & Claude: How Free Model Context Protocols Scale Delivery',
      'category': 'AI & Technology',
      'readTime': '6 min read',
      'imageUrl': 'https://images.unsplash.com/photo-1677442136019-21780efad99a?auto=format&fit=crop&w=1200&q=80',
      'tags': 'Cursor AI, Agentic Coding, Claude 3.7, MCP, Software Architecture',
      'excerpt': 'By interconnecting autonomous code agents with Anthropic’s Model Context Protocol (MCP), engineering teams are automating refactoring and test generation with 400% velocity gains.',
      'metric': '400% Feature Velocity Gain • Zero Context Drift • Open MCP Standard',
      'content': r'''# Autonomous Agentic Coding with Cursor & Claude: How Free Model Context Protocols Scale Delivery

### The Transition from Autocomplete to Autonomous Swarms
The developer tooling landscape has moved beyond single-line inline code completion. Today's engineering workflows leverage agentic swarms that read entire repository trees, execute unit tests in isolated subprocesses, and iterate until all assertions pass.

---

### Core Mechanics: The Model Context Protocol (MCP)
The breakthrough enabling multi-tool swarms is Anthropic's open **Model Context Protocol (MCP)**:
- **Client-Server Architecture**: Separates the LLM orchestrator from local tools, databases, and filesystem access.
- **Standardized Schemas**: Tools expose capabilities via JSON-RPC, enabling zero-shot tool selection without brittle regex prompt engineering.
- **Safe Execution Boundaries**: Grants granular read/write permissions per session.

---

### Benchmarking Agentic Velocity

```
+--------------------------------------------------------------------+
| TASK                         | MANUAL ESTIMATE | MCP AGENT SWARM   |
+--------------------------------------------------------------------+
| Full Test Suite Generation   | 4.5 Hours       | 8.2 Minutes       |
| API Migration Refactor       | 6.0 Hours       | 14.5 Minutes      |
| Dependency Vulnerability Fix | 2.0 Hours       | 3.1 Minutes       |
+--------------------------------------------------------------------+
```

---

### Practical Recommendation
Adopt open protocol architectures now to future-proof your development toolchain against proprietary IDE lock-in.''',
    },
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _excerptController.dispose();
    _contentController.dispose();
    _tagsController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _handleAiAutoFill() {
    final preset = _viralPresets[_selectedViralTopicIndex];
    setState(() {
      _titleController.text = preset['title'] as String;
      _selectedCategory = preset['category'] as String;
      _readTime = preset['readTime'] as String;
      _imageUrlController.text = preset['imageUrl'] as String;
      _tagsController.text = preset['tags'] as String;
      _excerptController.text = preset['excerpt'] as String;
      _contentController.text = preset['content'] as String;
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppTheme.primaryAccent,
        content: Text(
          '⚡ AI Auto-Fill complete for "${preset['name']}"! Review and edit before publishing.',
          style: GoogleFonts.inter(
            color: AppTheme.background,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _handlePublishCustomPost() {
    if (!_composerFormKey.currentState!.validate()) return;

    final tags = _tagsController.text
        .split(',')
        .map((t) => t.trim())
        .where((t) => t.isNotEmpty)
        .toList();

    final slug = _titleController.text
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');

    final preset = _viralPresets[_selectedViralTopicIndex];
    final sampleMetric = preset['metric'] as String? ?? 'Verified by Bibek Bhattarai • Admin Dispatch';

    final newPost = JournalPost(
      id: 'custom-${DateTime.now().millisecondsSinceEpoch}',
      title: _titleController.text.trim(),
      slug: slug,
      category: _selectedCategory,
      date: 'Published Just Now',
      readTime: _readTime,
      excerpt: _excerptController.text.trim(),
      contentMarkdown: _contentController.text.trim(),
      tags: tags.isNotEmpty ? tags : [_selectedCategory, 'Breaking', 'AI Tools'],
      statisticsHeadline: 'ADMIN DIRECT DISPATCH • LIVE BROADCAST',
      sampleMetric: sampleMetric,
      newsImageUrl: _imageUrlController.text.trim().isNotEmpty
          ? _imageUrlController.text.trim()
          : 'assets/images/products/app_feature_graphic.png',
      isFeatured: true,
    );

    context.read<PortfolioProvider>().publishCustomPost(newPost);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppTheme.primaryAccent,
        content: Text(
          'Post "${newPost.title}" successfully published to live News feed!',
          style: GoogleFonts.inter(
            color: AppTheme.background,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );

    _titleController.clear();
    _excerptController.clear();
    _contentController.clear();
    _tagsController.clear();

    setState(() {
      _isComposerExpanded = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PortfolioProvider>();
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 800;

    return Container(
      constraints: const BoxConstraints(maxWidth: 1200),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Executive Top Bar
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.border, width: 1.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryAccent.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.shield_rounded,
                          color: AppTheme.primaryAccent,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'EXECUTIVE CONSOLE',
                                  style: AppTheme.codeStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.primaryAccent,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.greenAccent.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                      color: Colors.greenAccent.withValues(alpha: 0.3),
                                    ),
                                  ),
                                  child: Text(
                                    'Logged in: admin',
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.greenAccent,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Portfolio Management & News Automation',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: isDesktop ? 22 : 18,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {
                        provider.setSection(PortfolioSection.journals);
                      },
                      icon: const Icon(Icons.newspaper_rounded, size: 16),
                      label: const Text('View News'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.textPrimary,
                        side: const BorderSide(color: AppTheme.border),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () {
                        provider.logoutAdmin();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: AppTheme.surfaceElevated,
                            content: Text(
                              'Admin logged out successfully.',
                              style: GoogleFonts.inter(color: AppTheme.textPrimary),
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.logout_rounded, size: 16),
                      label: const Text('Sign Out'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent.withValues(alpha: 0.2),
                        foregroundColor: Colors.redAccent,
                        elevation: 0,
                        side: BorderSide(color: Colors.redAccent.withValues(alpha: 0.4)),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Operational Statistics Overview
          Row(
            children: [
              Expanded(
                child: _buildMetricTile(
                  icon: Icons.auto_awesome_rounded,
                  label: 'AI NEWS SCHEDULE',
                  value: '2x Daily',
                  sub: '12:00 AM & 5:00 PM NPT',
                  accentColor: AppTheme.primaryAccent,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _buildMetricTile(
                  icon: Icons.show_chart_rounded,
                  label: 'TOTAL PLATFORM TRAFFIC',
                  value: '${provider.analyticsReport.totalVisits}',
                  sub: '${provider.analyticsReport.totalArticleViews} Article Reads',
                  accentColor: Colors.blueAccent,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _buildMetricTile(
                  icon: Icons.monetization_on_rounded,
                  label: 'ESTIMATED AD REVENUE',
                  value: '\$${provider.analyticsReport.totalRevenueUsd}',
                  sub: '${provider.analyticsReport.totalAdImpressions} Ad Impressions',
                  accentColor: Colors.greenAccent,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _buildMetricTile(
                  icon: Icons.mail_rounded,
                  label: 'CONTACT INQUIRIES',
                  value: '${provider.inquiries.length}',
                  sub: 'Received Messages',
                  accentColor: Colors.amberAccent,
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          // Navigation Tabs
          Row(
            children: [
              _buildTabButton(0, 'AI News Engine', Icons.smart_toy_rounded),
              const SizedBox(width: 8),
              _buildTabButton(1, 'Analytics & Revenue', Icons.insights_rounded),
              const SizedBox(width: 8),
              _buildTabButton(2, 'Inquiries (${provider.inquiries.length})', Icons.inbox_rounded),
              const SizedBox(width: 8),
              _buildTabButton(3, 'Cloud & DNS Ops', Icons.cloud_done_rounded),
            ],
          ),

          const SizedBox(height: 20),

          // Tab View Content
          if (_selectedTab == 0)
            _buildAiNewsTab(context, provider)
          else if (_selectedTab == 1)
            _buildAnalyticsTab(context, provider)
          else if (_selectedTab == 2)
            _buildInquiriesTab(context, provider)
          else
            _buildCloudOpsTab(context),
        ],
      ),
    );
  }

  Widget _buildTabButton(int index, String label, IconData icon) {
    final isSelected = _selectedTab == index;

    return InkWell(
      onTap: () => setState(() => _selectedTab = index),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryAccent.withValues(alpha: 0.15) : AppTheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppTheme.primaryAccent : AppTheme.border,
            width: 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? AppTheme.primaryAccent : AppTheme.textSecondary,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? AppTheme.primaryAccent : AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricTile({
    required IconData icon,
    required String label,
    required String value,
    required String sub,
    required Color accentColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  label,
                  style: AppTheme.codeStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Icon(icon, color: accentColor, size: 20),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            sub,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAiNewsTab(BuildContext context, PortfolioProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // AI Pipeline Status Card
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.border, width: 1.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Colors.greenAccent,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'GOOGLE GEMINI AUTOMATION PIPELINE',
                        style: AppTheme.codeStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.greenAccent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.greenAccent.withValues(alpha: 0.4)),
                    ),
                    child: Text(
                      'CRON ACTIVE',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.greenAccent,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'The Google Gemini 1.5 Flash automation workflow runs autonomously twice daily via GitHub Actions. It researches trending developments in AI, LLMs, and Health IT, drafts an editorial analysis with quantitative metrics, updates generated_ai_posts.dart, and automatically triggers Cloudflare Pages deployment.',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _buildScheduleBadge('Slot 1', '12:00 AM NPT', '18:15 UTC'),
                  _buildScheduleBadge('Slot 2', '05:00 PM NPT', '11:15 UTC'),
                  _buildScheduleBadge('Model', 'Gemini 1.5 Flash', 'Google AI Studio'),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  UrlService.launch(
                    'https://github.com/Bibekbvk/bibekprofile/actions/workflows/daily_ai_news.yml',
                  );
                },
                icon: const Icon(Icons.rocket_launch_rounded, size: 18),
                label: const Text('Open GitHub Actions to Run Pipeline Manually'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryAccent,
                  foregroundColor: AppTheme.background,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Manual Post Publisher / Composer
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isComposerExpanded
                  ? AppTheme.primaryAccent.withValues(alpha: 0.4)
                  : AppTheme.border,
              width: 1.0,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'EDITORIAL COMPOSER',
                        style: AppTheme.codeStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primaryAccent,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Publish Breaking Tech News Directly',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _isComposerExpanded = !_isComposerExpanded;
                      });
                    },
                    icon: Icon(
                      _isComposerExpanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.add_circle_outline_rounded,
                      color: AppTheme.primaryAccent,
                    ),
                    label: Text(
                      _isComposerExpanded ? 'Collapse Form' : 'Compose News Article',
                      style: GoogleFonts.inter(
                        color: AppTheme.primaryAccent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              if (_isComposerExpanded) ...[
                const SizedBox(height: 20),
                const Divider(color: AppTheme.border),
                const SizedBox(height: 20),
                Form(
                  key: _composerFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Viral AI Presets & Auto-Fill Section
                      Container(
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceElevated,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppTheme.primaryAccent.withValues(alpha: 0.3),
                            width: 1.0,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.auto_awesome, color: AppTheme.primaryAccent, size: 18),
                                const SizedBox(width: 8),
                                Text(
                                  'AI VIRAL NEWS AUTO-GENERATOR',
                                  style: AppTheme.codeStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.primaryAccent,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Select a trending viral AI topic below to auto-fill the headline, excerpt, benchmark metrics, code quickstart, and curated high-resolution photo.',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppTheme.textSecondary,
                                height: 1.45,
                              ),
                            ),
                            const SizedBox(height: 14),
                            DropdownButtonFormField<int>(
                              initialValue: _selectedViralTopicIndex,
                              dropdownColor: AppTheme.surface,
                              style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textPrimary),
                              decoration: _inputDecoration('Choose Viral AI Topic'),
                              items: List.generate(_viralPresets.length, (i) {
                                return DropdownMenuItem(
                                  value: i,
                                  child: Text(
                                    _viralPresets[i]['name'] as String,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              }),
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() => _selectedViralTopicIndex = val);
                                }
                              },
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton.icon(
                              onPressed: _handleAiAutoFill,
                              icon: const Icon(Icons.electric_bolt_rounded, size: 16),
                              label: const Text('Auto-Fill Full Article with AI'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryAccent.withValues(alpha: 0.2),
                                foregroundColor: AppTheme.primaryAccent,
                                elevation: 0,
                                side: const BorderSide(color: AppTheme.primaryAccent),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Title
                      Text(
                        'ARTICLE TITLE',
                        style: AppTheme.codeStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _titleController,
                        style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textPrimary),
                        decoration: _inputDecoration('e.g. Breakthrough in Autonomous Neural Architecture Search'),
                        validator: (val) => val == null || val.trim().isEmpty ? 'Title is required' : null,
                      ),

                      const SizedBox(height: 16),

                      // Cover Photo URL
                      Text(
                        'COVER PHOTO URL (HIGH-RES / UNSPLASH)',
                        style: AppTheme.codeStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _imageUrlController,
                        style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textPrimary),
                        decoration: _inputDecoration('https://images.unsplash.com/photo-...'),
                      ),

                      const SizedBox(height: 16),

                      // Category & Read Time Row
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'CATEGORY',
                                  style: AppTheme.codeStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                DropdownButtonFormField<String>(
                                  initialValue: _selectedCategory,
                                  dropdownColor: AppTheme.surfaceElevated,
                                  style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textPrimary),
                                  decoration: _inputDecoration(''),
                                  items: MockContentRepository.categories
                                      .where((c) => c != 'All')
                                      .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                                      .toList(),
                                  onChanged: (val) {
                                    if (val != null) setState(() => _selectedCategory = val);
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'READ TIME',
                                  style: AppTheme.codeStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                TextFormField(
                                  initialValue: _readTime,
                                  style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textPrimary),
                                  decoration: _inputDecoration('e.g. 6 min read'),
                                  onChanged: (val) => _readTime = val,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Excerpt
                      Text(
                        'SUMMARY / EXCERPT',
                        style: AppTheme.codeStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _excerptController,
                        maxLines: 2,
                        style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textPrimary),
                        decoration: _inputDecoration('A 2-sentence executive summary that grabs immediate attention...'),
                        validator: (val) => val == null || val.trim().isEmpty ? 'Excerpt is required' : null,
                      ),

                      const SizedBox(height: 16),

                      // Content Markdown
                      Text(
                        'CONTENT (MARKDOWN)',
                        style: AppTheme.codeStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _contentController,
                        maxLines: 8,
                        style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textPrimary),
                        decoration: _inputDecoration('# Heading\n\nDetailed breakdown and architectural findings...'),
                        validator: (val) => val == null || val.trim().isEmpty ? 'Content is required' : null,
                      ),

                      const SizedBox(height: 16),

                      // Tags
                      Text(
                        'TAGS (COMMA SEPARATED)',
                        style: AppTheme.codeStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _tagsController,
                        style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textPrimary),
                        decoration: _inputDecoration('AI, Neural Networks, Agentic Workflows'),
                      ),

                      const SizedBox(height: 24),

                      ElevatedButton.icon(
                        onPressed: _handlePublishCustomPost,
                        icon: const Icon(Icons.send_rounded, size: 18),
                        label: const Text('Publish Immediately to Live Feed'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryAccent,
                          foregroundColor: AppTheme.background,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInquiriesTab(BuildContext context, PortfolioProvider provider) {
    if (provider.inquiries.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(48),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.border),
        ),
        child: Column(
          children: [
            const Icon(Icons.inbox_rounded, size: 48, color: AppTheme.textSecondary),
            const SizedBox(height: 16),
            Text(
              'No Inquiries in Current Session',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'When visitors submit messages via the Contact section, they will appear here.',
              style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textSecondary),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'RECEIVED INQUIRIES (${provider.inquiries.length})',
              style: AppTheme.codeStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppTheme.primaryAccent,
              ),
            ),
            TextButton.icon(
              onPressed: () {
                provider.clearInquiries();
              },
              icon: const Icon(Icons.clear_all_rounded, size: 16),
              label: const Text('Clear Inbox'),
              style: TextButton.styleFrom(foregroundColor: AppTheme.textSecondary),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...provider.inquiries.map((inquiry) {
          final name = inquiry['name'] ?? 'Anonymous';
          final email = inquiry['email'] ?? '';
          final message = inquiry['message'] ?? '';
          final date = inquiry['date'] ?? '';

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: AppTheme.primaryAccent.withValues(alpha: 0.2),
                          child: Text(
                            name.isNotEmpty ? name[0].toUpperCase() : '?',
                            style: GoogleFonts.inter(
                              color: AppTheme.primaryAccent,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            Text(
                              email,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      date,
                      style: AppTheme.codeStyle(
                        fontSize: 11,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceElevated,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: Text(
                    message,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppTheme.textPrimary,
                      height: 1.45,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {
                        UrlService.launch(
                          'mailto:$email?subject=Re: Advisory Consultation with Bibek Bhattarai',
                        );
                      },
                      icon: const Icon(Icons.reply_rounded, size: 16),
                      label: const Text('Reply via Email'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.primaryAccent,
                        side: const BorderSide(color: AppTheme.primaryAccent),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildCloudOpsTab(BuildContext context) {
    return Column(
      children: [
        _buildServiceCard(
          title: 'Cloudflare Pages Deployment',
          sub: 'Project: bibekprofile • Production Branch: source',
          icon: Icons.cloud_done_rounded,
          url: 'https://dash.cloudflare.com/',
          status: 'Active & Verified',
          statusColor: Colors.greenAccent,
        ),
        const SizedBox(height: 12),
        _buildServiceCard(
          title: 'GitHub CI/CD & AI Workflow Repository',
          sub: 'Repository: Bibekbvk/bibekprofile • Daily 12 AM / 5 PM Cron',
          icon: Icons.code_rounded,
          url: 'https://github.com/Bibekbvk/bibekprofile',
          status: 'Repository Healthy',
          statusColor: Colors.greenAccent,
        ),
        const SizedBox(height: 12),
        _buildServiceCard(
          title: 'Google Search Console (GSC)',
          sub: 'Indexed Property: https://www.bhattaraibvk.com.np/',
          icon: Icons.search_rounded,
          url: 'https://search.google.com/search-console',
          status: 'Sitemaps Submitted',
          statusColor: Colors.blueAccent,
        ),
        const SizedBox(height: 12),
        _buildServiceCard(
          title: 'Google Play Developer Console',
          sub: 'Publisher Account • Machhamart Live Production APK',
          icon: Icons.shop_rounded,
          url: AppConstants.machhamartPlayStoreUrl,
          status: 'Store Published',
          statusColor: Colors.greenAccent,
        ),
      ],
    );
  }

  Widget _buildServiceCard({
    required String title,
    required String sub,
    required IconData icon,
    required String url,
    required String status,
    required Color statusColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceElevated,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: AppTheme.primaryAccent, size: 22),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    sub,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                ),
                child: Text(
                  status,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                icon: const Icon(Icons.open_in_new_rounded, size: 18),
                color: AppTheme.textSecondary,
                tooltip: 'Open in new tab',
                onPressed: () => UrlService.launch(url),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleBadge(String label, String value, String sub) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.surfaceElevated,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: AppTheme.codeStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          Text(
            sub,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.inter(
        fontSize: 13,
        color: AppTheme.textSecondary.withValues(alpha: 0.6),
      ),
      filled: true,
      fillColor: AppTheme.surfaceElevated,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppTheme.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppTheme.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppTheme.primaryAccent, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    );
  }

  Widget _buildAnalyticsTab(BuildContext context, PortfolioProvider provider) {
    final report = provider.analyticsReport;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 900;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Analytics Header & Period Filter Toolbar
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.border, width: 1.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                color: Colors.greenAccent,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'TRAFFIC & MONETIZATION INTELLIGENCE',
                              style: AppTheme.codeStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.primaryAccent,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Real-Time Readership, Ad Placements & Revenue Reporting',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: isDesktop ? 20 : 16,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          provider.simulateTrafficPulse();
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: AppTheme.primaryAccent,
                              content: Text(
                                '⚡ Simulated real-time organic reader burst: +45 to 80 views, ad impressions & telemetry logged!',
                                style: GoogleFonts.inter(
                                  color: AppTheme.background,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.bolt_rounded, size: 16),
                        label: const Text('Simulate Traffic Pulse'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryAccent,
                          foregroundColor: AppTheme.background,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          textStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700),
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => _showExportReportDialog(context, provider),
                        icon: const Icon(Icons.file_download_rounded, size: 16),
                        label: const Text('Export Audit Report'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.textPrimary,
                          side: const BorderSide(color: AppTheme.border),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          textStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 18),
              const Divider(color: AppTheme.border),
              const SizedBox(height: 14),

              // Filter Time Horizon
              Wrap(
                spacing: 8,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    'REPORTING TIMEFRAME:',
                    style: AppTheme.codeStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  ...AnalyticsTimeFilter.values.map((filter) {
                    final isSelected = provider.analyticsTimeFilter == filter;
                    return InkWell(
                      onTap: () => provider.setAnalyticsTimeFilter(filter),
                      borderRadius: BorderRadius.circular(6),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppTheme.primaryAccent.withValues(alpha: 0.2)
                              : AppTheme.surfaceElevated,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: isSelected ? AppTheme.primaryAccent : AppTheme.border,
                            width: 1.0,
                          ),
                        ),
                        child: Text(
                          filter.label,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: isSelected ? AppTheme.primaryAccent : AppTheme.textSecondary,
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // 4 KPI Summary Cards
        Row(
          children: [
            Expanded(
              child: _buildKpiCard(
                icon: Icons.people_alt_rounded,
                title: 'TOTAL PLATFORM VISITS',
                value: '${report.totalVisits}',
                sub: 'Live recorded traffic (Zero Dummy Data)',
                subColor: Colors.greenAccent,
                accentColor: Colors.blueAccent,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _buildKpiCard(
                icon: Icons.menu_book_rounded,
                title: 'ARTICLE READS / VIEWS',
                value: '${report.totalArticleViews}',
                sub: 'Across all technical news',
                subColor: AppTheme.textSecondary,
                accentColor: AppTheme.primaryAccent,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _buildKpiCard(
                icon: Icons.ads_click_rounded,
                title: 'TOTAL AD IMPRESSIONS',
                value: '${report.totalAdImpressions}',
                sub: '${report.totalAdClicks} Clicks • ${report.overallCtr}% CTR',
                subColor: Colors.amberAccent,
                accentColor: Colors.amberAccent,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _buildKpiCard(
                icon: Icons.payments_rounded,
                title: 'ESTIMATED AD REVENUE',
                value: '\$${report.totalRevenueUsd}',
                sub: '≈ NPR ${report.totalRevenueNpr.toStringAsFixed(0)} (eCPM \$${report.averageEcpm.toStringAsFixed(2)})',
                subColor: Colors.greenAccent,
                accentColor: Colors.greenAccent,
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Weekly Views & Revenue Trend Bar Chart
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.border, width: 1.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'DAILY TRAFFIC & EARNINGS VELOCITY',
                          style: AppTheme.codeStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primaryAccent,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Weekly Day-by-Day Volume & Revenue Trajectory',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Row(
                    children: [
                      _buildLegendDot(AppTheme.primaryAccent, 'Daily Pageviews'),
                      const SizedBox(width: 16),
                      _buildLegendDot(Colors.greenAccent, 'Estimated Revenue (\$)'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildWeeklyChart(report.dailyTrends),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Ad Inventory & Performance Breakdown (Which Ads Displayed)
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.border, width: 1.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AD PLACEMENT INVENTORY & UNIT PERFORMANCE',
                          style: AppTheme.codeStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primaryAccent,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Which Ads Displayed, Impressions, Clicks, and Revenue per Unit',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.greenAccent.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.greenAccent.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      '3 MONETIZATION SLOTS ACTIVE',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.greenAccent,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Column(
                children: report.adUnits.map((ad) => _buildAdUnitCard(ad)).toList(),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Article Traffic & Revenue Leaderboard
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.border, width: 1.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CONTENT AUDIT & ARTICLE TRAFFIC LEADERBOARD',
                          style: AppTheme.codeStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primaryAccent,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Pageviews, Ad Displays, and Revenue Contribution per Article',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${report.articleStats.length} Total Articles Indexed',
                    style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondary),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              _buildArticleLeaderboard(report.articleStats),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Google AdSense Readiness & Verification Summary
        _buildAdSenseGuidanceCard(),
      ],
    );
  }

  Widget _buildKpiCard({
    required IconData icon,
    required String title,
    required String value,
    required String sub,
    required Color subColor,
    required Color accentColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTheme.codeStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, color: accentColor, size: 16),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            sub,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: subColor,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyChart(List<DailyTrendStat> dailyTrends) {
    if (dailyTrends.isEmpty) return const SizedBox.shrink();
    final maxViews = dailyTrends.map((d) => d.views).reduce((a, b) => a > b ? a : b);

    return SizedBox(
      height: 210,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: dailyTrends.map((stat) {
          final heightRatio = maxViews > 0 ? (stat.views / maxViews) : 0.2;
          final barHeight = 20.0 + (heightRatio * 80.0);

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '\$${stat.revenue.toStringAsFixed(2)}',
                    style: AppTheme.codeStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Colors.greenAccent,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    height: barHeight,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppTheme.primaryAccent,
                          AppTheme.primaryAccent.withValues(alpha: 0.35),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    stat.day,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  Text(
                    '${stat.views} views',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLegendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondary),
        ),
      ],
    );
  }

  Widget _buildAdUnitCard(AdUnitStat ad) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.surfaceElevated,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.border),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 700;

          final infoSection = Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.primaryAccent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.view_compact_rounded, color: AppTheme.primaryAccent, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            ad.name,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.greenAccent.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.greenAccent.withValues(alpha: 0.3)),
                          ),
                          child: Text(
                            ad.status,
                            style: GoogleFonts.inter(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: Colors.greenAccent,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${ad.placement} • ${ad.format}',
                      style: GoogleFonts.inter(fontSize: 11, color: AppTheme.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          );

          final statsRow = SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildStatPill('DISPLAYS', '${ad.impressions}', Colors.blueAccent),
                const SizedBox(width: 18),
                _buildStatPill('CLICKS', '${ad.clicks}', Colors.amberAccent),
                const SizedBox(width: 18),
                _buildStatPill('CTR', '${ad.ctr.toStringAsFixed(2)}%', Colors.cyanAccent),
                const SizedBox(width: 18),
                _buildStatPill('eCPM', '\$${ad.eCpm.toStringAsFixed(2)}', AppTheme.primaryAccent),
                const SizedBox(width: 18),
                _buildStatPill('REVENUE', '\$${ad.revenue.toStringAsFixed(2)}', Colors.greenAccent),
              ],
            ),
          );

          if (isNarrow) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                infoSection,
                const SizedBox(height: 14),
                statsRow,
              ],
            );
          }

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(flex: 5, child: infoSection),
              const SizedBox(width: 16),
              statsRow,
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatPill(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: AppTheme.codeStyle(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildArticleLeaderboard(List<ArticleTrafficStat> articles) {
    return Column(
      children: articles.map((a) {
        final rank = articles.indexOf(a) + 1;
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppTheme.surfaceElevated,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.border),
          ),
          child: Row(
            children: [
              Container(
                width: 26,
                height: 26,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: rank <= 3 ? AppTheme.primaryAccent : AppTheme.surface,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$rank',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: rank <= 3 ? AppTheme.background : AppTheme.textSecondary,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      a.title,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      a.category,
                      style: GoogleFonts.inter(fontSize: 11, color: AppTheme.textSecondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 4,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('READERS', style: AppTheme.codeStyle(fontSize: 9, color: AppTheme.textSecondary)),
                        Text('${a.views}', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('AD DISPLAYS', style: AppTheme.codeStyle(fontSize: 9, color: AppTheme.textSecondary)),
                        Text('${a.adImpressions}', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.blueAccent)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('REVENUE', style: AppTheme.codeStyle(fontSize: 9, color: AppTheme.textSecondary)),
                        Text('\$${a.revenue}', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.greenAccent)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: AppTheme.border),
                ),
                child: Text(
                  a.trendBadge,
                  style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAdSenseGuidanceCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primaryAccent.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.monetization_on_rounded, color: Colors.greenAccent, size: 22),
                  const SizedBox(width: 8),
                  Text(
                    'GOOGLE ADSENSE MONETIZATION & ACCOUNT SETUP',
                    style: AppTheme.codeStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primaryAccent,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amberAccent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.amberAccent.withValues(alpha: 0.3)),
                ),
                child: Text(
                  'STATUS: LINKED (ca-pub-3634340207015593)',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.greenAccent,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'Google AdSense Publisher ID ca-pub-3634340207015593 is linked to your website. Both the official Google AdSense script in web/index.html and the authorized ads.txt file have been deployed live.',
            style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textSecondary, height: 1.5),
          ),
          const SizedBox(height: 16),
          // Step by Step guide box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surfaceElevated,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'GOOGLE ADSENSE INTEGRATION STATUS:',
                  style: AppTheme.codeStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primaryAccent,
                  ),
                ),
                const SizedBox(height: 10),
                _buildAdStep('1', 'AdSense Publisher Account: pub-3634340207015593 (Active).'),
                _buildAdStep('2', 'Official AdSense script embedded in web/index.html.'),
                _buildAdStep('3', 'Authorized ads.txt deployed at https://www.bhattaraibvk.com.np/ads.txt.'),
                _buildAdStep('4', 'Under AdSense Sites, add https://www.bhattaraibvk.com.np to request domain approval.'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              ElevatedButton.icon(
                onPressed: () => UrlService.launch('https://adsense.google.com/start/'),
                icon: const Icon(Icons.open_in_new_rounded, size: 16),
                label: const Text('Login to Google AdSense'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryAccent,
                  foregroundColor: AppTheme.background,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  textStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700),
                ),
              ),
              OutlinedButton.icon(
                onPressed: () => UrlService.launch('https://www.bhattaraibvk.com.np/privacy-policy.html'),
                icon: const Icon(Icons.shield_outlined, size: 16),
                label: const Text('View Live Privacy Policy'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.textPrimary,
                  side: const BorderSide(color: AppTheme.border),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  textStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildComplianceBadge('Privacy Policy Live', 'https://www.bhattaraibvk.com.np/privacy-policy.html', true),
              _buildComplianceBadge('Ad Slots Ready', 'Mid-article & sidebar banners coded', true),
              _buildComplianceBadge('Zero Dummy Data', '100% real live visitor metrics', true),
              _buildComplianceBadge('Automated Daily Articles', '2x Daily via Gemini 1.5 Flash', true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAdStep(String stepNumber, String instruction) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20,
            height: 20,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppTheme.primaryAccent.withValues(alpha: 0.2),
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.primaryAccent, width: 1),
            ),
            child: Text(
              stepNumber,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppTheme.primaryAccent,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              instruction,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: AppTheme.textPrimary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComplianceBadge(String label, String sub, bool isDone) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.surfaceElevated,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isDone ? Icons.check_circle_rounded : Icons.pending_rounded,
            color: isDone ? Colors.greenAccent : Colors.amberAccent,
            size: 16,
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
              Text(sub, style: GoogleFonts.inter(fontSize: 10, color: AppTheme.textSecondary)),
            ],
          ),
        ],
      ),
    );
  }

  void _showExportReportDialog(BuildContext context, PortfolioProvider provider) {
    final csvData = provider.analytics.exportCsvReport(provider.analyticsTimeFilter);
    final jsonData = provider.analytics.exportJsonReport(provider.analyticsTimeFilter);
    bool showJson = false;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final activeData = showJson ? jsonData : csvData;
            return AlertDialog(
              backgroundColor: AppTheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: AppTheme.border),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Export Analytics & Revenue Report',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () => setModalState(() => showJson = false),
                        child: Text(
                          'CSV',
                          style: TextStyle(
                            color: !showJson ? AppTheme.primaryAccent : AppTheme.textSecondary,
                            fontWeight: !showJson ? FontWeight.w700 : FontWeight.w400,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => setModalState(() => showJson = true),
                        child: Text(
                          'JSON',
                          style: TextStyle(
                            color: showJson ? AppTheme.primaryAccent : AppTheme.textSecondary,
                            fontWeight: showJson ? FontWeight.w700 : FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              content: SizedBox(
                width: 650,
                height: 380,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceElevated,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: SingleChildScrollView(
                    child: SelectableText(
                      activeData,
                      style: AppTheme.codeStyle(fontSize: 11, color: AppTheme.textPrimary),
                    ),
                  ),
                ),
              ),
              actions: [
                OutlinedButton.icon(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: activeData));
                    Navigator.of(ctx).pop();
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: AppTheme.primaryAccent,
                        content: Text(
                          '📋 ${showJson ? "JSON" : "CSV"} report copied to clipboard!',
                          style: GoogleFonts.inter(color: AppTheme.background, fontWeight: FontWeight.w600),
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.copy_rounded, size: 16),
                  label: const Text('Copy to Clipboard'),
                  style: OutlinedButton.styleFrom(foregroundColor: AppTheme.primaryAccent),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryAccent,
                    foregroundColor: AppTheme.background,
                  ),
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
