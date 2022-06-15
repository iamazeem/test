#include <test.h>
#include <utf8proc.h>

int main()
{
    printf("utf8proc_version: %s\n", utf8proc_version());
    test();
    return 0;
}
