#include <stdio.h>
#define CSTAR_IMPLEMENTATION
#include "cstar.h"

int main(int argc, char ** argv) {
    cst_log(0, "testandow, 123");
    cst_tracelog(CST_ERROR, "viji, vacilou");
    cst_tracelog(CST_WARNING, "carain");

    int i = 0;
    cst_assert(i != 0);

    printf("C Start Project\n");
    return 0;
}
