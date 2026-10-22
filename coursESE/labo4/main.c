#include "stm32f7xx_hal.h"

#include <stdint.h>


/*
static const uint32_t cie1931[101] =
{
	  0,   0,   1,   1,  1,    1,   2,   2,   2,   3,
	  3,   3,   4,   4,  4,    5,   5,   6,   6,   7,
	  8,   8,   9,  10,  10,  11,  12,  13,  14,  15,
	 16,  17,  18,  19,  20,  22,  23,  24,  26,  27,
	 29,  30,  32,  34,  35,  37,  39,  41,  43,  45,
	 47,  49,  51,  54,  56,  58,  61,  64,  66,  69,
	 72,  75,  78,  81,  84,  87,  90,  93,  97, 100,
	104, 108, 111, 115, 119, 123, 127, 131, 136, 140,
	145, 149, 154, 159, 163, 168, 173, 179, 184, 189,
	195, 200, 206, 212, 217, 223, 230, 236, 242, 248,
	255,
};
*/


void ledsInit();

int main(void)
{
	GPIO_InitTypeDef GPIO_InitStruct;

  /* GPIO Ports Clock Enable */
  __HAL_RCC_GPIOB_CLK_ENABLE();

  /* Configure GPIO pin: PF9 (GPIO_DEBUG) */
  GPIO_InitStruct.Pin  = GPIO_PIN_9;
  GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  HAL_GPIO_Init(GPIOB, &GPIO_InitStruct);
	
	for(;;)
	{
		// TODO
		ledsInit();
	}
}
