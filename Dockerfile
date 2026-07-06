ARG WORKER_COMFYUI_IMAGE=runpod/worker-comfyui:5.8.6-base
FROM ${WORKER_COMFYUI_IMAGE}

ENV DEBIAN_FRONTEND=noninteractive
ENV PIP_PREFER_BINARY=1

WORKDIR /comfyui

# LTX 2.3 uses core ComfyUI LTX nodes. The base worker image keeps the
# RunPod serverless handler and /start.sh entrypoint intact.
RUN mkdir -p \
    models/checkpoints \
    models/text_encoders \
    models/loras \
    models/latent_upscale_models

# Main LTX 2.3 checkpoint and distilled motion LoRA.
RUN wget -q --show-progress \
      -O models/checkpoints/ltx-2.3-22b-dev.safetensors \
      https://huggingface.co/Lightricks/LTX-2.3/resolve/main/ltx-2.3-22b-dev.safetensors \
  && wget -q --show-progress \
      -O models/loras/ltx-2.3-22b-distilled-lora-384-1.1.safetensors \
      https://huggingface.co/Lightricks/LTX-2.3/resolve/main/ltx-2.3-22b-distilled-lora-384-1.1.safetensors \
  && wget -q --show-progress \
      -O models/latent_upscale_models/ltx-2.3-spatial-upscaler-x2-1.1.safetensors \
      https://huggingface.co/Lightricks/LTX-2.3/resolve/main/ltx-2.3-spatial-upscaler-x2-1.1.safetensors

# Audio VAE must be visible to LTXVAudioVAELoader's checkpoint dropdown.
RUN wget -q --show-progress \
      -O models/checkpoints/LTX23_audio_vae_bf16.safetensors \
      https://huggingface.co/Kijai/LTX2.3_comfy/resolve/main/vae/LTX23_audio_vae_bf16.safetensors

# Audio text encoder and Gemma LoRA used by the FusionInteract workflow.
RUN wget -q --show-progress \
      -O models/text_encoders/gemma_3_12B_it_fp4_mixed.safetensors \
      https://huggingface.co/Comfy-Org/ltx-2/resolve/main/split_files/text_encoders/gemma_3_12B_it_fp4_mixed.safetensors \
  && wget -q --show-progress \
      -O models/loras/gemma-3-12b-it-abliterated_lora_rank64_bf16.safetensors \
      https://huggingface.co/Comfy-Org/ltx-2/resolve/main/split_files/loras/gemma-3-12b-it-abliterated_lora_rank64_bf16.safetensors

# Keep the upstream serverless handler/entrypoint.
CMD ["/start.sh"]
