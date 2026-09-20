-- ==============================================================================
-- SUPABASE DATABASE SCHEMA SCRIPT
-- Project: Bibek Bhattarai Portfolio & Dynamic Journal Web App
-- Created: September 2026
-- ==============================================================================

-- 1. Enable pgcrypto for UUID generation
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ==============================================================================
-- TABLE: posts (Articles, Research Journals & Essays)
-- ==============================================================================
CREATE TABLE IF NOT EXISTS public.posts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title TEXT NOT NULL,
    slug TEXT UNIQUE NOT NULL,
    category TEXT NOT NULL, -- Tech, Health, Management, General Philosophy
    read_time TEXT NOT NULL DEFAULT '7 min read',
    excerpt TEXT NOT NULL,
    content TEXT NOT NULL, -- Rich text in Markdown format
    tags TEXT[] DEFAULT '{}',
    is_featured BOOLEAN DEFAULT false,
    is_published BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

-- Index on slug and category for rapid filtering
CREATE INDEX IF NOT EXISTS idx_posts_slug ON public.posts (slug);
CREATE INDEX IF NOT EXISTS idx_posts_category ON public.posts (category);
CREATE INDEX IF NOT EXISTS idx_posts_published ON public.posts (is_published);

-- ==============================================================================
-- TABLE: study_notes (Technical Reference Summaries & Analytical Digests)
-- ==============================================================================
CREATE TABLE IF NOT EXISTS public.study_notes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title TEXT NOT NULL,
    description TEXT NOT NULL,
    category TEXT NOT NULL, -- Tech, Health, Management, General Philosophy
    file_url TEXT NOT NULL,
    format TEXT NOT NULL DEFAULT 'Reference Guide', -- Technical Whitepaper, Analytical Model, etc.
    key_takeaways TEXT[] DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_study_notes_category ON public.study_notes (category);

-- ==============================================================================
-- TABLE: contact_messages (Inquiries from Portfolio Visitors)
-- ==============================================================================
CREATE TABLE IF NOT EXISTS public.contact_messages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    email TEXT NOT NULL,
    message TEXT NOT NULL,
    is_read BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- ==============================================================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- ==============================================================================

-- Enable RLS on all tables
ALTER TABLE public.posts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.study_notes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.contact_messages ENABLE ROW LEVEL SECURITY;

-- 1. Posts Policies:
-- Anyone can view published posts
CREATE POLICY "Public users can view published posts" 
ON public.posts 
FOR SELECT 
USING (is_published = true);

-- Only authenticated users (admins) can modify posts
CREATE POLICY "Admins can insert and update posts" 
ON public.posts 
FOR ALL 
TO authenticated 
USING (true) 
WITH CHECK (true);

-- 2. Study Notes Policies:
-- Anyone can view study notes
CREATE POLICY "Public users can view study notes" 
ON public.study_notes 
FOR SELECT 
USING (true);

-- Only authenticated users (admins) can modify study notes
CREATE POLICY "Admins can manage study notes" 
ON public.study_notes 
FOR ALL 
TO authenticated 
USING (true) 
WITH CHECK (true);

-- 3. Contact Messages Policies:
-- Anyone can insert a contact message (Public inquiry submission)
CREATE POLICY "Anyone can submit a contact message" 
ON public.contact_messages 
FOR INSERT 
WITH CHECK (true);

-- Only authenticated admins can read/update contact messages
CREATE POLICY "Admins can view contact inquiries" 
ON public.contact_messages 
FOR SELECT 
TO authenticated 
USING (true);

-- ==============================================================================
-- SEED DATA (INITIAL SAMPLE RECORDS)
-- ==============================================================================

INSERT INTO public.posts (title, slug, category, read_time, excerpt, content, tags, is_featured)
VALUES 
(
    'Optimizing Clinical Workflows with Modern Distributed Systems',
    'optimizing-clinical-workflows-distributed-systems',
    'Health',
    '8 min read',
    'How decoupled event-driven architectures and offline-first edge data caching eliminate latency in acute hospital care pipelines.',
    E'# Optimizing Clinical Workflows with Modern Distributed Systems\n\nModern healthcare networks are complex socio-technical systems where latency isn\'t just an inconvenience—it directly impacts patient triage.\n\n### The Latency Bottleneck\nTraditional monolithic EHR systems were engineered around centralized relational databases designed primarily for billing.\n\n### Event Streaming Paradigm\nDecoupled edge microservices ensure immediate bedside record captures even during upstream network dropouts.',
    ARRAY['Health Informatics', 'Distributed Systems', 'Operations'],
    true
),
(
    'Strategic Healthcare Management: Balancing Cost, Compliance, and Agility',
    'strategic-healthcare-management-balancing-cost-agility',
    'Management',
    '11 min read',
    'A strategic roadmap for healthcare executives to drive operational agility without compromising regulatory compliance or fiscal health.',
    E'# Strategic Healthcare Management\n\nHealthcare management resides at the volatile intersection of regulatory mandates and escalating operational costs.',
    ARRAY['Strategic Planning', 'Healthcare Finance', 'Governance'],
    false
)
ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.study_notes (title, description, category, file_url, format, key_takeaways)
VALUES 
(
    'HL7 FHIR & Clinical Interoperability Architecture',
    'Deep dive into modern FHIR RESTful resources, SMART-on-FHIR OAuth profiles, and real-time subscription mechanisms for health record exchange.',
    'Health',
    'https://hl7.org/fhir/',
    'Technical Whitepaper',
    ARRAY['Resource-oriented JSON modeling', 'SMART-on-FHIR OAuth plug-in profiles', 'Bulk Data Access specifications']
),
(
    'High-Throughput Queueing Theory in Hospital Admissions',
    'Applying M/M/c queuing formulas and stochastic simulations to predict bed bottlenecks and emergency triage diversion rates.',
    'Management',
    'https://en.wikipedia.org/wiki/Queueing_theory',
    'Analytical Model',
    ARRAY['Stochastic patient arrival distributions', 'Erlang C capacity modeling', 'Emergency diversion prevention']
);
