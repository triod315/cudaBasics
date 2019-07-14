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

void add(int*a, int*b, int*c) {
    for (int i=0;i<=N;i++){
        c[i]=a[i]+b[i];
    }
}

void doIt(int* sample,ofstream &fout){
    clock_t begin=clock();

    int *a,*b,*c;  //host variables
    
    int size=N*sizeof(int);

   
    a=sample;

    //b = (int *)malloc(size);
    b=sample;

    c = (int *)malloc(size);

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