// Cloudflare Pages Function: Serverless Edge AI Endpoint using Cloudflare Workers AI
export async function onRequestPost(context) {
  const corsHeaders = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type',
    'Content-Type': 'application/json',
  };

  try {
    const body = await context.request.json();
    const userPrompt = body.prompt || body.message || 'Introduce Bibek Bhattarai';

    // System context detailing Bibek Bhattarai's credentials and verified applications
    const systemPrompt = `You are the AI assistant representing Bibek Bhattarai's official portfolio (bhattaraibvk.com.np).
Bibek Bhattarai is a multidisciplinary technologist with expertise bridging Enterprise IT, Healthcare Systems, and Strategic Business Management.
Credentials:
- B.Ed (4 Years) at Tribhuvan University (Sanothimi Campus, Bhaktapur)
- MBA at Pokhara University
- BSc (Hons) Computing at London Metropolitan University
- Diploma in General Medicine (Health Assistant - HA) from CTEVT
- SLC (Distinction)

Verified Google Play Console Applications:
1. Machhamart (com.machhamart) - Production, live on Google Play Store. Fresh seafood and aquaculture cold-chain logistics in Nepal.
2. Android Health (com.mobilehealth.droidpulse.mobile_health) - Closed testing. Clinical telemetry and vitals diagnostics.
3. Search Everything (com.devicefinder.app.device_finder) - Closed testing. Fast on-device file & metadata indexer.
4. 3D MS Trader (com.mstrader.com) - Closed testing. Quantitative financial market indicators.

Keep answers concise, polished, and professional.`;

    // If Cloudflare Workers AI binding is present
    if (context.env && context.env.AI) {
      const aiResponse = await context.env.AI.run('@cf/meta/llama-3.1-8b-instruct', {
        messages: [
          { role: 'system', content: systemPrompt },
          { role: 'user', content: userPrompt },
        ],
        max_tokens: 512,
      });

      return new Response(
        JSON.stringify({
          success: true,
          response: aiResponse.response || aiResponse,
          model: '@cf/meta/llama-3.1-8b-instruct',
        }),
        { headers: corsHeaders }
      );
    }

    // Fallback response when binding is being attached
    return new Response(
      JSON.stringify({
        success: true,
        response: `Hello! I am Bibek Bhattarai's portfolio AI assistant powered by Cloudflare Workers AI. You asked: "${userPrompt}". Bibek specializes in Enterprise IT, Clinical Telemetry, and Quantitative Biostatistics.`,
        model: 'edge-fallback',
      }),
      { headers: corsHeaders }
    );
  } catch (error) {
    return new Response(
      JSON.stringify({
        success: false,
        error: error.message,
      }),
      { status: 500, headers: corsHeaders }
    );
  }
}

export async function onRequestOptions() {
  return new Response(null, {
    headers: {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
      'Access-Control-Allow-Headers': 'Content-Type',
    },
  });
}
