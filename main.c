#include <stdio.h>
#define CSTAR_IMPLEMENTATION
#include "cstar.h"

int main(int argc, char ** argv) {
    cst_log(0, "testandow, 123");
    cst_trace("viji, vacilou");
    cst_trace("carain");

    int i = 1;
    cst_log("vai dar ruim? %d != 0", i);
    cst_assert(i != 0);

    cst_fatal("err, deu ruim");

    printf("C Start Project\n");
    return 0;
}
