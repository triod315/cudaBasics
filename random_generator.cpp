#include <fstream>
#include <iostream>
#include <vector>


using namespace std;

vector<int> genRandomArray(int n){
    vector<int> resultv;
    for (int i=0;i<n;i++)
    {
        resultv.push_back(rand()%1000);
    }
    return resultv;
}

void wiriteVector(vector<int> vec){
    ofstream out("samples.txt",ios_base::app);
    out<<vec.size()<<endl;
    for (int i=0;i<vec.size();i++){
        out<<vec[i]<<" ";
    }
    out<<endl;
    
}

int main(int argc, char ** argv){
    int sample_count=stoi(argv[1]);
    int step=stoi(argv[2]);

    cout<<"Sample count: "<<sample_count<<endl;
    cout<<"step"<<step<<endl;
    srand(time(NULL));
    for (int i=0;i<sample_count;i++){
        wiriteVector(genRandomArray(step));
        cout<<"Sample N"<<i<<" with size"<<step<<endl;
        step+=step/2;
    }

    
    
}