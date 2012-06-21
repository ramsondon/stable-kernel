/*
 * omap3evm.c  -- ALSA SoC support for OMAP3 EVM
 *
 * Author: Anuj Aggarwal <anuj.aggarwal@ti.com>
 *
 * Based on sound/soc/omap/beagle.c by Steve Sakoman
 *
 * Copyright (C) 2008 Texas Instruments, Incorporated
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the
 * Free Software Foundation version 2.
 *
 * This program is distributed "as is" WITHOUT ANY WARRANTY of any kind,
 * whether express or implied; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * General Public License for more details.
 */

#include <linux/clk.h>
#include <linux/platform_device.h>
#include <linux/module.h>
#include <sound/core.h>
#include <sound/pcm.h>
#include <sound/soc.h>

#include <asm/mach-types.h>
#include <mach/hardware.h>
#include <mach/gpio.h>
#include <plat/mcbsp.h>

#include "omap-mcbsp.h"
#include "omap-pcm.h"

static int omap3evm_hw_params(struct snd_pcm_substream *substream,
	struct snd_pcm_hw_params *params)
{
	struct snd_soc_pcm_runtime *rtd = substream->private_data;
	struct snd_soc_dai *codec_dai = rtd->codec_dai;
	int ret;

	/* Set the codec system clock for DAC and ADC */
	ret = snd_soc_dai_set_sysclk(codec_dai, 0, 26000000,
				     SND_SOC_CLOCK_IN);
	if (ret < 0) {
		printk(KERN_ERR "Can't set codec system clock\n");
		return ret;
	}

	return 0;
}

static struct snd_soc_ops omap3evm_ops = {
	.hw_params = omap3evm_hw_params,
};

/* Digital audio interface glue - connects codec <--> CPU */
static struct snd_soc_dai_link omap3evm_dai = {
	.name 		= "TWL4030",
	.stream_name 	= "TWL4030",
	.cpu_dai_name = "omap-mcbsp-dai.1",
	.codec_dai_name = "twl4030-hifi",
	.platform_name = "omap-pcm-audio",
	.codec_name = "twl4030-codec",
	.dai_fmt = SND_SOC_DAIFMT_I2S | SND_SOC_DAIFMT_NB_NF |
		   SND_SOC_DAIFMT_CBM_CFM,
	.ops 		= &omap3evm_ops,
};

/* Audio machine driver */
static struct snd_soc_card snd_soc_omap3evm = {
	.name = "omap3evm",
	.dai_link = &omap3evm_dai,
	.num_links = 1,
};

static int __devinit omap3evm_soc_probe(struct platform_device *pdev)
{
	struct snd_soc_card *card = &snd_soc_omap3evm;
	int ret;

	pr_info("OMAP3 EVM SoC init\n");

	card->dev = &pdev->dev;

	ret = snd_soc_register_card(card);
	if (ret) {
		dev_err(&pdev->dev, "snd_soc_register_card() failed: %d\n",
			ret);
		return ret;
	}

	return 0;
}

static int __devexit omap3evm_soc_remove(struct platform_device *pdev)
{
	struct snd_soc_card *card = platform_get_drvdata(pdev);

	snd_soc_unregister_card(card);

	return 0;
}

static struct platform_driver omap3evm_driver = {
	.driver = {
		.name = "omap3evm-soc-audio",
		.owner = THIS_MODULE,
	},

	.probe = omap3evm_soc_probe,
	.remove = __devexit_p(omap3evm_soc_remove),
};

static int __init omap3evm_soc_init(void)
{
	return platform_driver_register(&omap3evm_driver);
}
module_init(omap3evm_soc_init);

static void __exit omap3evm_soc_exit(void)
{
	platform_driver_unregister(&omap3evm_driver);
}
module_exit(omap3evm_soc_exit);

MODULE_AUTHOR("Anuj Aggarwal <anuj.aggarwal@ti.com>");
MODULE_DESCRIPTION("ALSA SoC OMAP3 EVM");
MODULE_LICENSE("GPL v2");
MODULE_ALIAS("platform:omap3evm-soc-audio");
