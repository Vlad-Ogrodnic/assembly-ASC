#include <iostream>
#include <fstream>
using namespace std;

void add(int desc, float d, int v[], int size)
{
    int i = 0;
    float s = (d >= 16) ? d / 8 : 2; // daca d>=16 space needed=d/8 altfel space needed=2
    while (i <= 1027 - s)
    {
        bool can_insert = true;
        for (int j = 0; j < s; j++)
        {
            if (v[i + j] != 0)
            {
                can_insert = false;
                break;
            }
        }
        if (can_insert)
        {
            for (int j = 0; j < s; j++)
            {
                v[i + j] = desc;
            }
            return;
        }
        i++;
    }
    cout << "Not enough space to insert " << desc << " with size " << s << endl;
}

void get(int id, int v[], int &b, int &k)
{
    int i;
    k = 0;
    for (i = 0; i <= 1025; i++)
    {
        if (v[i] == id)
        {
            b = i;
            while (v[i] == id && i <= 1025)
            {
                k++;
                i++;
            }
            break;
        }
    }
    cout << b << " " << b + k - 1 << endl;
}

void del(int id, int v[])
{
    for (int i = 0; i <1025; ++i)
    {
        if (v[i] == id)
        {
            v[i] = 0;
        }
    }
}
void defrag(int v[]) {
    int i = 0, j = 0;
    while (j < 1025) {
        if (v[j] != 0) {
            v[i++] = v[j];
        }
        j++;
    }
    while (i < 1025) {
        v[i++] = 0;
    }
}

int main()
{
    int v[1027] = {0};
    int b, k;
    add(1, 124, v, 1027);
    add(4, 350, v, 1027);
    add(121,75,v,1027);
    add(254,1024,v,1027);
    add(70,30,v,1027);
    for (int i = 0; i < 1027; ++i)
    {
        cout << v[i] << " ";
    }
    cout << endl;
    get(121, v, b, k);
    cout << endl;
    del(4,v);
    defrag(v);
    for (int i = 0; i < 1027; ++i)
    {
        cout << v[i] << " ";
    }
    cout << endl;
    return 0;
}

