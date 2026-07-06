# FusionInteract LTX 2.3 Serverless Worker

This Docker context builds a RunPod Serverless ComfyUI worker for FusionInteract
image-to-video jobs.

It is based on `runpod/worker-comfyui:5.8.6-base`, so it keeps the RunPod
serverless `/run`, `/runsync`, `/status`, and `/health` handler behavior.

The image bakes in the LTX 2.3 model files required by
`www/account/workflows/video_ltx2_3_i2v.json`:

- `models/checkpoints/ltx-2.3-22b-dev.safetensors`
- `models/checkpoints/LTX23_audio_vae_bf16.safetensors`
- `models/text_encoders/gemma_3_12B_it_fp4_mixed.safetensors`
- `models/loras/ltx-2.3-22b-distilled-lora-384-1.1.safetensors`
- `models/loras/gemma-3-12b-it-abliterated_lora_rank64_bf16.safetensors`
- `models/latent_upscale_models/ltx-2.3-spatial-upscaler-x2-1.1.safetensors`

## Deploy

Use RunPod's Serverless GitHub build flow or build and push this image yourself:

```bash
docker build -t your-registry/fusioninteract-ltx23-serverless:latest .
docker push your-registry/fusioninteract-ltx23-serverless:latest
```

Then update the RunPod endpoint Docker image to that pushed image.

Keep the endpoint API key in RunPod/FusionInteract private config only. Do not
add keys to this Docker context.
