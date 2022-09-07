# SPDX-License-Identifier: GPL-2.0
# ROCKCHIP Platform Support

snd-soc-rockchip-audio-pwm-objs := rockchip_audio_pwm.o
snd-soc-rockchip-i2s-tdm-objs := rockchip_i2s_tdm.o
snd-soc-rockchip-spdifrx-objs := rockchip_spdifrx.o
snd-soc-rockchip-vad-objs := rockchip_vad.o
ifdef CONFIG_THUMB2_KERNEL
snd-soc-rockchip-vad-$(CONFIG_THUMB2_KERNEL) += vad_preprocess_thumb.o
else
snd-soc-rockchip-vad-$(CONFIG_ARM64) += vad_preprocess_arm64.o
snd-soc-rockchip-vad-$(CONFIG_ARM) += vad_preprocess_arm.o
endif

obj-$(CONFIG_SND_SOC_ROCKCHIP_AUDIO_PWM) += snd-soc-rockchip-audio-pwm.o
obj-$(CONFIG_SND_SOC_ROCKCHIP_I2S_TDM) += snd-soc-rockchip-i2s-tdm.o
obj-$(CONFIG_SND_SOC_ROCKCHIP_SPDIFRX) += snd-soc-rockchip-spdifrx.o
obj-$(CONFIG_SND_SOC_ROCKCHIP_VAD) += snd-soc-rockchip-vad.o

snd-soc-rockchip-hdmi-objs := rockchip_hdmi.o
snd-soc-rockchip-multicodecs-objs := rockchip_multicodecs.o

obj-$(CONFIG_SND_SOC_ROCKCHIP_HDMI) += snd-soc-rockchip-hdmi.o
obj-$(CONFIG_SND_SOC_ROCKCHIP_MULTICODECS) += snd-soc-rockchip-multicodecs.o
