#include "cuda_runtime.h"
#include "stdio.h"

__global__ void printData(int* _dDataPtr)
{
    printf("%d",_dDataPtr[threadIdx.x]);
}

__global__ void setData(int* _dDataPtr)
{
    _dDataPtr[threadIdx.x] = 2;
}


int main()
{
    int data[10] = {0,};
    for(int i = 0 ; i < 10 ; i++)
    {
        data[i] = 1;
    }
    int* dDataPtr;
    cudaMalloc(&dDataPtr, sizeof(int) * 10);
    cudaMemset(dDataPtr, 0x00, sizeof(int) * 10);
    
    printf("Data in device: ");
    printData<<<1, 10>>>(dDataPtr);

    cudaMemcpy( dDataPtr, data, sizeof(int) * 10, cudaMemcpyHostToDevice);
    printf("\nHost -> Devices :");
    printData<<<1, 10>>>(dDataPtr);

    setData<<<1, 10>>>(dDataPtr);

    cudaMemcpy( data, dDataPtr, sizeof(int) * 10, cudaMemcpyDeviceToHost);
    printf("\nDevices -> Host :");
    for(int i = 0 ; i < 10 ; i++)
    {
        printf("%d",data[i]);
    }



    cudaFree( dDataPtr);


}    