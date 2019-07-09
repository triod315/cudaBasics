#include <iostream>

__global__ void add(int*a, int*b, int*c) {*c = *a + *b;}

int main(void){
    int a,b,c;  //host variables
    int *d_a, *d_b, *d_c; //device variables
    int size=sizeof(int);

    //allocate space on device for a,b and c
    cudaMalloc((void**)&d_a, size);
    cudaMalloc((void**)&d_b, size);
    cudaMalloc((void**)&d_c, size);

    a=1;
    b=1;

    cudaMemcpy(d_a, &a, size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, &b, size, cudaMemcpyHostToDevice);

    add<<<1,1>>>(d_a,d_b,d_c);
    
    cudaMemcpy(&c, d_c, size, cudaMemcpyDeviceToHost);

    cudaDeviceSynchronize();
    cudaError_t error=cudaGetLastError();

    if(error!=cudaSuccess){
        printf("Error: %s\n",cudaGetErrorString(error));
    }

    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);

    printf("%d",c);
    return 0;
}
