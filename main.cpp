#include <iostream>
#include <string>

// clang-format off
int
add(int a, int b);
// clang-format on
float add(float a, float b);
int add(int a, int b);

int add(int a, int b)
{
    //
    return a + b;
}

int global_variable = 1;
#define DEBUG 1

template <class T>
class Hoge {
public:
    Hoge() {}

private:
    void Hello(T t) {}
};

float add(float a, float b)
{
    //
    return a + b;
}

struct Sample {
public:
};

int add(int a, int b)
{
    //
    return a + b;
}

int main(int argc, char* argv[])
{
    // NOTE: no local class decl to ctags (without l option)
    class LocalHoge {
    public:
        LocalHoge();
    };
    // NOTE: no local struct decl to ctags (without l option)
    struct LocalSample {
    public:
    };
    add();
    std::cout << "hello\tworld" << std::endl;
    return 0;
}
