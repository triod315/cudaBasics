#include<fstream>
#include<iostream>
#include<vector>
#include<ctime>

using namespace std;

int N;

vector<int> readVector(ifstream &fin)
{
    
    //fin.open();

    int n;
    int c;
    fin>>n;

    vector<int> result;
    for (int i=0;i<n;i++){
        fin>>c;
        result.push_back(c);        
    }
    N=n;
    return result;
}

__global__ void add(int*a, int*b, int*c) {
    c[blockIdx.x] = a[blockIdx.x] + b[blockIdx.x];
}

void doIt(int* sample,ofstream &fout){
    clock_t begin=clock();

    int *a,*b,*c;  //host variables
    int *d_a, *d_b, *d_c; //device variables
    int size=N*sizeof(int);

    cudaMalloc((void**)&d_a, size);
    cudaMalloc((void**)&d_b, size);
    cudaMalloc((void**)&d_c, size);

    //a = (int *)malloc(size);
    a=sample;

    //b = (int *)malloc(size);
    b=sample;

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
    cout<<endl<<N<<"|"<<a[N-1]<<"+"<<b[N-1]<<"="<<c[N-1]<<std::endl;
    std::cout<<"done\n";
    //free(a);
    //free(b);
    free(c);
    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);

    clock_t end=clock();
    double elapsed_secs = double(end - begin) / CLOCKS_PER_SEC;
    cout<<". Elapsed time: "<<elapsed_secs<<endl;
    fout<<"{"<<N<<", "<<elapsed_secs<<"},";
}



int main(int argc, char ** argv)
{
    cout<<"file name: "<<argv[1]<<endl;
    cout<<"Sample count: "<<argv[2]<<endl;
    string fileName=argv[1];
    int sample_count=stoi(argv[2]);
    //cout<<"Sample count: "<<sample_count<<endl;
    vector<int> sample;

    ifstream fin(fileName);
    ofstream fout("result.txt");


    for (int i=0;i<sample_count;i++){
        cout<<"Sample №"<<i;
        sample=readVector(fin);
        doIt(&sample[0],fout);
        
    }
    fout.close();
    return 0;
}