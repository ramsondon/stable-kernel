/* include/linux/ks8851.h
 *
 * Platform specific configuration data for KS8851 driver.
 *
 * Copyright 2009 Simtec Electronics
 *	http://www.simtec.co.uk/
 *	Ben Dooks <ben@simtec.co.uk>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 */

/**
 * struct ks8851_pdata - platform specific configuration data
 * @irq_flags: The IRQ trigger flags to pass to request_irq().
 *
 * Platform specific configuration to be passed from board support
 * registering the spi device to the driver.
 */
struct ks8851_pdata {
	unsigned	irq_flags;
};
