#!/usr/bin/env bash
set -euo pipefail

COMFYUI_DIR="${COMFYUI_DIR:-/comfyui}"
VOLUME_DIR="${RUNPOD_VOLUME_PATH:-/runpod-volume}"

if [ -d "$VOLUME_DIR" ] && [ -w "$VOLUME_DIR" ]; then
  MODEL_ROOT="${FUSION_LTX_MODEL_ROOT:-$VOLUME_DIR/comfyui/models}"
else
  MODEL_ROOT="${FUSION_LTX_MODEL_ROOT:-$COMFYUI_DIR/models}"
fi

mkdir -p \
  "$MODEL_ROOT/checkpoints" \
  "$MODEL_ROOT/text_encoders" \
  "$MODEL_ROOT/loras" \
  "$MODEL_ROOT/latent_upscale_models" \
  "$COMFYUI_DIR/models/checkpoints" \
  "$COMFYUI_DIR/models/text_encoders" \
  "$COMFYUI_DIR/models/loras" \
  "$COMFYUI_DIR/models/latent_upscale_models"

download_file() {
  local target="$1"
  local url="$2"
  local tmp="${target}.part"

  if [ -s "$target" ]; then
    echo "Model ready: $target"
    return 0
  fi

  echo "Downloading model: $(basename "$target")"
  rm -f "$tmp"
  if command -v wget >/dev/null 2>&1; then
    wget -q -O "$tmp" "$url"
  else
    curl -fsSL "$url" -o "$tmp"
  fi
  mv "$tmp" "$target"
}

link_model() {
  local source="$1"
  local dest="$2"

  if [ "$source" = "$dest" ]; then
    return 0
  fi

  if [ ! -e "$dest" ]; then
    ln -s "$source" "$dest"
  fi
}

download_file "$MODEL_ROOT/checkpoints/ltx-2.3-22b-dev.safetensors" \
  "https://huggingface.co/Lightricks/LTX-2.3/resolve/main/ltx-2.3-22b-dev.safetensors"
download_file "$MODEL_ROOT/checkpoints/LTX23_audio_vae_bf16.safetensors" \
  "https://huggingface.co/Kijai/LTX2.3_comfy/resolve/main/vae/LTX23_audio_vae_bf16.safetensors"
download_file "$MODEL_ROOT/text_encoders/gemma_3_12B_it_fp4_mixed.safetensors" \
  "https://huggingface.co/Comfy-Org/ltx-2/resolve/main/split_files/text_encoders/gemma_3_12B_it_fp4_mixed.safetensors"
download_file "$MODEL_ROOT/loras/ltx-2.3-22b-distilled-lora-384-1.1.safetensors" \
  "https://huggingface.co/Lightricks/LTX-2.3/resolve/main/ltx-2.3-22b-distilled-lora-384-1.1.safetensors"
download_file "$MODEL_ROOT/loras/gemma-3-12b-it-abliterated_lora_rank64_bf16.safetensors" \
  "https://huggingface.co/Comfy-Org/ltx-2/resolve/main/split_files/loras/gemma-3-12b-it-abliterated_lora_rank64_bf16.safetensors"
download_file "$MODEL_ROOT/latent_upscale_models/ltx-2.3-spatial-upscaler-x2-1.1.safetensors" \
  "https://huggingface.co/Lightricks/LTX-2.3/resolve/main/ltx-2.3-spatial-upscaler-x2-1.1.safetensors"

link_model "$MODEL_ROOT/checkpoints/ltx-2.3-22b-dev.safetensors" \
  "$COMFYUI_DIR/models/checkpoints/ltx-2.3-22b-dev.safetensors"
link_model "$MODEL_ROOT/checkpoints/LTX23_audio_vae_bf16.safetensors" \
  "$COMFYUI_DIR/models/checkpoints/LTX23_audio_vae_bf16.safetensors"
link_model "$MODEL_ROOT/text_encoders/gemma_3_12B_it_fp4_mixed.safetensors" \
  "$COMFYUI_DIR/models/text_encoders/gemma_3_12B_it_fp4_mixed.safetensors"
link_model "$MODEL_ROOT/loras/ltx-2.3-22b-distilled-lora-384-1.1.safetensors" \
  "$COMFYUI_DIR/models/loras/ltx-2.3-22b-distilled-lora-384-1.1.safetensors"
link_model "$MODEL_ROOT/loras/gemma-3-12b-it-abliterated_lora_rank64_bf16.safetensors" \
  "$COMFYUI_DIR/models/loras/gemma-3-12b-it-abliterated_lora_rank64_bf16.safetensors"
link_model "$MODEL_ROOT/latent_upscale_models/ltx-2.3-spatial-upscaler-x2-1.1.safetensors" \
  "$COMFYUI_DIR/models/latent_upscale_models/ltx-2.3-spatial-upscaler-x2-1.1.safetensors"

echo "FusionInteract LTX 2.3 models are provisioned."
