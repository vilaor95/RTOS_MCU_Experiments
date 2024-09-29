#ifndef UTIL_H
#define UTIL_H

/* Macro definitions */
#define UNUSED(x) ((void) x)

static inline unsigned long bitmask(unsigned int bits)
{
	unsigned long bmask = 0;
	for (unsigned int i = 0; i < bits; i++) {
		bmask |= ((1L)<<i);
	}
	return bmask;
}

static inline void clear_bit(unsigned long* word, unsigned int position)
{
	*word &= ~((1L)<<position);
}

static inline void set_bit(unsigned long *word, unsigned int position)
{
	*word |= ((1L)<<position);
}

static inline void toggle_bit(unsigned long *word, unsigned int position)
{
	*word ^= ((1L)<<position);
}

static inline void clear_all_bits(unsigned long *word)
{
	*word &= 0L;
}

static inline void clear_bits(unsigned long *word, unsigned int position, unsigned int numberOfBits)
{
	*word &= ~((bitmask(numberOfBits))<<position);
}

static inline void set_bits(unsigned long *word, unsigned int position, unsigned int numberOfBits, unsigned int value)
{
	unsigned long tmp = *word;

	clear_bits(&tmp, position, numberOfBits); 
	tmp |= ((value)<<position);
	
	*word = tmp;
}

#endif
