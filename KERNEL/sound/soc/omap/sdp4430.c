/*
 * sdp4430.c  --  SoC audio for TI OMAP4430 SDP
 *
 * Author: Misael Lopez Cruz <x0052729@ti.com>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * version 2 as published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
 * 02110-1301 USA
 *
 */

#include <linux/clk.h>
#include <linux/platform_device.h>
#include <linux/mfd/twl6040.h>
#include <linux/module.h>

#include <sound/core.h>
#include <sound/pcm.h>
#include <sound/soc.h>
#include <sound/jack.h>

#include <asm/mach-types.h>
#include <plat/hardware.h>
#include <plat/mux.h>

#include "omap-mcpdm.h"
#include "omap-pcm.h"
#include "../codecs/twl6040.h"

static int sdp4430_hw_params(struct snd_pcm_substream *substream,
	struct snd_pcm_hw_params *params)
{
	struct snd_soc_pcm_runtime *rtd = substream->private_data;
	struct snd_soc_dai *codec_dai = rtd->codec_dai;
	int clk_id, freq;
	int ret;

	clk_id = twl6040_get_clk_id(rtd->codec);
	if (clk_id == TWL6040_SYSCLK_SEL_HPPLL)
		freq = 38400000;
	else if (clk_id == TWL6040_SYSCLK_SEL_LPPLL)
		freq = 32768;
	else
		return -EINVAL;

	/* set the codec mclk */
	ret = snd_soc_dai_set_sysclk(codec_dai, clk_id, freq,
				SND_SOC_CLOCK_IN);
	if (ret) {
		printk(KERN_ERR "can't set codec system clock\n");
		return ret;
	}
	return ret;
}

static struct snd_soc_ops sdp4430_ops = {
	.hw_params = sdp4430_hw_params,
};

/* Headset jack */
static struct snd_soc_jack hs_jack;

/*Headset jack detection DAPM pins */
static struct snd_soc_jack_pin hs_jack_pins[] = {
	{
		.pin = "Headset Mic",
		.mask = SND_JACK_MICROPHONE,
	},
	{
		.pin = "Headset Stereophone",
		.mask = SND_JACK_HEADPHONE,
	},
};

/* SDP4430 machine DAPM */
static const struct snd_soc_dapm_widget sdp4430_twl6040_dapm_widgets[] = {
	SND_SOC_DAPM_MIC("Ext Mic", NULL),
	SND_SOC_DAPM_SPK("Ext Spk", NULL),
	SND_SOC_DAPM_MIC("Headset Mic", NULL),
	SND_SOC_DAPM_HP("Headset Stereophone", NULL),
	SND_SOC_DAPM_SPK("Earphone Spk", NULL),
	SND_SOC_DAPM_INPUT("FM Stereo In"),
};

static const struct snd_soc_dapm_route audio_map[] = {
	/* External Mics: MAINMIC, SUBMIC with bias*/
	{"MAINMIC", NULL, "Main Mic Bias"},
	{"SUBMIC", NULL, "Main Mic Bias"},
	{"Main Mic Bias", NULL, "Ext Mic"},

	/* External Speakers: HFL, HFR */
	{"Ext Spk", NULL, "HFL"},
	{"Ext Spk", NULL, "HFR"},

	/* Headset Mic: HSMIC with bias */
	{"HSMIC", NULL, "Headset Mic Bias"},
	{"Headset Mic Bias", NULL, "Headset Mic"},

	/* Headset Stereophone (Headphone): HSOL, HSOR */
	{"Headset Stereophone", NULL, "HSOL"},
	{"Headset Stereophone", NULL, "HSOR"},

	/* Earphone speaker */
	{"Earphone Spk", NULL, "EP"},

	/* Aux/FM Stereo In: AFML, AFMR */
	{"AFML", NULL, "FM Stereo In"},
	{"AFMR", NULL, "FM Stereo In"},
};

static int sdp4430_twl6040_init(struct snd_soc_pcm_runtime *rtd)
{
	struct snd_soc_codec *codec = rtd->codec;
	int ret, hs_trim;

	/*
	 * Configure McPDM offset cancellation based on the HSOTRIM value from
	 * twl6040.
	 */
	hs_trim = twl6040_get_trim_value(codec, TWL6040_TRIM_HSOTRIM);
	omap_mcpdm_configure_dn_offsets(rtd, TWL6040_HSF_TRIM_LEFT(hs_trim),
					TWL6040_HSF_TRIM_RIGHT(hs_trim));

	/* Headset jack detection */
	ret = snd_soc_jack_new(codec, "Headset Jack",
				SND_JACK_HEADSET, &hs_jack);
	if (ret)
		return ret;

	ret = snd_soc_jack_add_pins(&hs_jack, ARRAY_SIZE(hs_jack_pins),
				hs_jack_pins);

	if (machine_is_omap_4430sdp())
		twl6040_hs_jack_detect(codec, &hs_jack, SND_JACK_HEADSET);
	else
		snd_soc_jack_report(&hs_jack, SND_JACK_HEADSET, SND_JACK_HEADSET);

	return ret;
}

/* Digital audio interface glue - connects codec <--> CPU */
static struct snd_soc_dai_link sdp4430_dai = {
	.name = "TWL6040",
	.stream_name = "TWL6040",
	.cpu_dai_name = "omap-mcpdm",
	.codec_dai_name = "twl6040-legacy",
	.platform_name = "omap-pcm-audio",
	.codec_name = "twl6040-codec",
	.init = sdp4430_twl6040_init,
	.ops = &sdp4430_ops,
};

/* Audio machine driver */
static struct snd_soc_card snd_soc_sdp4430 = {
	.name = "SDP4430",
	.dai_link = &sdp4430_dai,
	.num_links = 1,

	.dapm_widgets = sdp4430_twl6040_dapm_widgets,
	.num_dapm_widgets = ARRAY_SIZE(sdp4430_twl6040_dapm_widgets),
	.dapm_routes = audio_map,
	.num_dapm_routes = ARRAY_SIZE(audio_map),
};

static int __devinit sdp4430_soc_probe(struct platform_device *pdev)
{
	struct snd_soc_card *card = &snd_soc_sdp4430;
	int ret;

	pr_info("SDP4430 SoC init\n");

	card->dev = &pdev->dev;

	ret = snd_soc_register_card(card);
	if (ret) {
		dev_err(&pdev->dev, "snd_soc_register_card() failed: %d\n",
			ret);
		return ret;
	}

	return 0;
}

static int __devexit sdp4430_soc_remove(struct platform_device *pdev)
{
	struct snd_soc_card *card = platform_get_drvdata(pdev);

	snd_soc_unregister_card(card);

	return 0;
}

static struct platform_driver sdp4430_driver = {
	.driver = {
		.name = "sdp4430-soc-audio",
		.owner = THIS_MODULE,
	},

	.probe = sdp4430_soc_probe,
	.remove = __devexit_p(sdp4430_soc_remove),
};

static int __init sdp4430_soc_init(void)
{
	return platform_driver_register(&sdp4430_driver);
}
module_init(sdp4430_soc_init);

static void __exit sdp4430_soc_exit(void)
{
	platform_driver_unregister(&sdp4430_driver);
}
module_exit(sdp4430_soc_exit);

MODULE_AUTHOR("Misael Lopez Cruz <x0052729@ti.com>");
MODULE_DESCRIPTION("ALSA SoC SDP4430");
MODULE_LICENSE("GPL");
MODULE_ALIAS("platform:sdp4430-soc-audio");
