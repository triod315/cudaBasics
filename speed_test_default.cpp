#include<fstream>
#include<iostream>
#include<vector>
#include<ctime>
#include<math.h>

using namespace std;

int N;

vector<float> readVector(ifstream &fin)
{
    
    //fin.open();

    int n;
    int c;
    fin>>n;

    vector<float> result;
    for (int i=0;i<n;i++){
        fin>>c;
        result.push_back(c);        
    }
    N=n;
    return result;
}

void add(float*a, float*b, float*c) {
    for (int i=0;i<=N;i++){
        c[i]=sin(cos(sin(a[i])))+sin(cos(sin(b[i])));
    }
}

void doIt(float* sample,ofstream &fout){
    clock_t begin=clock();

    float *a,*b,*c;  //host variables
    
    int size=N*sizeof(float);

   
    a=sample;

    //b = (int *)malloc(size);
    b=sample;

    c = (float *)malloc(size);

    add(a,b,c);

    free(c);
  

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
    vector<float> sample;

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