#include "stm32f7xx_hal.h"

#include <stdint.h>
#include "clock_216.h"

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
void front();
void setLed(uint32_t );
void setMulLed(uint32_t, ...);

volatile uint32_t * SYSTICK_CTRL = (uint32_t*)0xE000E010;

#define RESET 0x0
#define CODE (0xE << 28)
#define INTENSITY_MAX (0x1F << 25)
#define RED_MAX (0xff)
#define GREEN_MAX (0xff << 7)
#define BLUE_MAX (0xff << 15)
#define NBLED 20


uint32_t newCode(uint32_t intensity, uint32_t RED, uint32_t GREEN, uint32_t BLUE){
		uint32_t t =  (CODE) | (intensity << 25) | (BLUE << 16) | (GREEN<<8) | (RED) ;
		return t;
}




int main(void)
{
	/*
	SystemClock_Config();
	*SYSTICK_CTRL = 0;					// Disable SysTick
	*/
	GPIO_InitTypeDef GPIO_InitStruct;

  /* GPIO Ports Clock Enable */
  __HAL_RCC_GPIOB_CLK_ENABLE();

  /* Configure GPIO pin: PF9 (GPIO_DEBUG) */
  GPIO_InitStruct.Pin  = GPIO_PIN_9;
  GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  HAL_GPIO_Init(GPIOB, &GPIO_InitStruct);
  GPIO_InitStruct.Pin  = GPIO_PIN_10;
  GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  HAL_GPIO_Init(GPIOB, &GPIO_InitStruct);
  GPIO_InitStruct.Pin  = GPIO_PIN_14;
  GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  HAL_GPIO_Init(GPIOB, &GPIO_InitStruct);
  GPIO_InitStruct.Pin  = GPIO_PIN_15;
  GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  HAL_GPIO_Init(GPIOB, &GPIO_InitStruct);
	
	
	
	uint32_t tabLed[20];
	for (int i = 0; i< NBLED; i++){
			tabLed[i] = newCode(0, 255, 0, 0);
	}
	
	
	
	setLed(0x0);
	for (int i = 0; i<20 ; i ++){
		setLed(0xE0);
	}
	
	for(;;)
	{
		setLed(RESET);
		setMulLed(20, 0xffff0000, 0xff00ff00, 0xff0000ff, 0xffffFFFF, 0xffff0000, 0xff00ff00, 0xff0000ff, 0xffffFFFF, 0xffff0000, 0xff00ff00, 0xff0000ff, 0xffffFFFF, 0xffff0000, 0xff00ff00, 0xff0000ff, 0xffffFFFF, 0xffff0000, 0xff00ff00, 0xff0000ff, 0xffffFFFF);
		setLed(RESET);
	}
}
