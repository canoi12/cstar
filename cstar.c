#include <stdio.h>
#include <stdlib.h>

int main(int argc, char ** argv) {
    printf("******* welcome to cstar *******\n");

    printf("1. download musl\n");
    printf("2. compile code\n");
    printf("3. setup\n");
    printf("e. exit\n");
    printf("? ");
    int o;
    scanf("%d", &o);
    
    printf("you choose %d\n", o);

    return 0;
}
