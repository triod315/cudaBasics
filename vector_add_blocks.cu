#include <iostream>

__global__ void add(int*a, int*b, int*c) 
{
    c[blockIdx.x] = a[blockIdx.x] + b[blockIdx.x];
}

void random_ints(int* a, int N)
{
   int i;
   for (i = 0; i < N; ++i)
    {
        a[i] = rand()%1000;
    }
}

#define N 1000000000
int main(void){
    int *a,*b,*c;  //host variables
    int *d_a, *d_b, *d_c; //device variables
    int size=N*sizeof(int);

    //allocate space on device for a,b and c
    cudaMalloc((void**)&d_a, size);
    cudaMalloc((void**)&d_b, size);
    cudaMalloc((void**)&d_c, size);

    a = (int *)malloc(size);
    random_ints(a, N);

    b = (int *)malloc(size);
    random_ints(b, N);

    c = (int *)malloc(size);

    cudaMemcpy(d_a, a, size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, b, size, cudaMemcpyHostToDevice);

    //launch kernel for N blocks
    add<<<N,1>>>(d_a,d_b,d_c);
    
    cudaMemcpy(c, d_c, size, cudaMemcpyDeviceToHost);

    cudaDeviceSynchronize();
    cudaError_t error=cudaGetLastError();

    if(error!=cudaSuccess){
        printf("Error: %s\n",cudaGetErrorString(error));
    }

    /*for (int i=0;i<N;i++)
    {
        std::cout<<a[i]<<"+"<<b[i]<<"="<<c[i]<<std::endl;
    }
    */
    std::cout<<"done\n";
    free(a);
    free(b);
    free(c);
    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);

    return 0;
}
