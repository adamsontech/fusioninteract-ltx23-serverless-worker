ARG WORKER_COMFYUI_IMAGE=runpod/worker-comfyui:fix-dr-1170-ngc-base-blackwell-base-cuda12.8.1
FROM ${WORKER_COMFYUI_IMAGE}

ENV DEBIAN_FRONTEND=noninteractive
ENV PIP_PREFER_BINARY=1

WORKDIR /comfyui

# Keep the Docker build small. RunPod GitHub builds have a 30 minute limit,
# and exporting an image with the full LTX 2.3 model set exceeds it.
COPY scripts/provision_ltx23_models.sh /usr/local/bin/provision_ltx23_models.sh
COPY scripts/fusioninteract-start.sh /usr/local/bin/fusioninteract-start.sh
RUN chmod +x /usr/local/bin/provision_ltx23_models.sh /usr/local/bin/fusioninteract-start.sh

CMD ["/usr/local/bin/fusioninteract-start.sh"]
