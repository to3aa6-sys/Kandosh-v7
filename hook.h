#ifndef hook_h
#define hook_h

#include <stdbool.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

// Fixed: Changed return type to void to match the call in ImGuiDrawView.mm
void hook(void *address[], void *function[], int count);

#ifdef __cplusplus
}
#endif

#endif /* hook_h */
