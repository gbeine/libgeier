#ifndef _BSD_BASE64_H
#define _BSD_BASE64_H

int b64_ntop(unsigned char const *src, size_t srclength,
	     char *target, size_t targsize);
int
b64_pton(char const *src, size_t srcsize,
	 unsigned char *target, size_t targsize);

#endif /* _BSD_BASE64_H */
