#include <stdio.h>
#include <stdlib.h>

void MoveDisk (int diskNumber, int startPost, int endPost, int midPost) 
  { if (diskNumber > 1) 
       { MoveDisk (diskNumber-1,startPost, midPost, endPost); 
         printf ("Move disk %d from post %d to post %d.\n",
                 diskNumber, startPost, endPost);
         MoveDisk (diskNumber-1, midPost, endPost, startPost);
       } 
    else 
       { printf ("Move disk 1 from post %d to post %d.\n", 
                  startPost, endPost);
       }
    return;
  }

int main () 
  {  int n;
     printf ("--Towers of Hanoi--\nHow many disks? ");
     scanf ("%d", &n);
     printf ("Instructions to move %d disks from post 1 to post 3:\n",n);
     MoveDisk (n,1,3,2);
     return 0;
  }