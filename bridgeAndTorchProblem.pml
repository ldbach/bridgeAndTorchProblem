/*
spin -a bridgeAndTorchProblem.pml
gcc -o pan pan.c
./pan
spin -t -p -l bridgeAndTorchProblem.pml // this one for the time for 4 people to reach the right side of the bridge, which is less than 15 minutes
*/
#define N 4
// the left side of the bridge, at the begining there are all four people
byte leftSide[N];
// the condition that 2 people did reach the other end of the bridge
bool two_finished;
// the condition that one person did come back to the left side of the bridge
bool didComeBack;
// the time 
int time;
// the right side of the bridge, at the beginning there is no person there
byte rightSide[N];
// the condition that all 4 people reach the right side of the bridge
bool finished; 
// the function move the people from left to right side of the bridge
proctype moveToRight() {
    // the array chooses which person to come from left to right, each time chooses 2 random people
    byte move[2];
    // the first person is j
    byte j;
    // the max value of time for the 2 people
    byte i;
    if 
     :: leftSide[0] != 0 -> j = leftSide[0]
     :: leftSide[1] != 0 -> j = leftSide[1]
     :: leftSide[2] != 0 -> j = leftSide[2]
     :: leftSide[3] != 0 -> j = leftSide[3]
    fi;
    // the second person is k, k muss be different from j
    byte k;
    again:
    if 
     :: leftSide[0] != 0 -> k = leftSide[0]
     :: leftSide[1] != 0 -> k = leftSide[1]
     :: leftSide[2] != 0 -> k = leftSide[2]
     :: leftSide[3] != 0 -> k = leftSide[3]
    fi;
    do
     :: k == j -> goto again;
     :: k != j -> break;
    od
    // first person moves
    move[0] = j; 
    leftSide[j - 1] = 0; 
    rightSide[j - 1] = j; 
    // second person moves
    move[1] = k; 
    leftSide[k - 1] = 0; 
    rightSide[k - 1] = k; 
    if
     :: move[0] > move[1] -> i = move[0];
     :: move[1] > move[0] -> i = move[1]; 
    fi;
    if
      :: i == 1 -> time = time + 1
      :: i == 2 -> time = time + 2
      :: i == 3 -> time = time + 5
      :: i == 4 -> time = time + 8
    fi;
    // print out the result
    printf("People on the left side of the bridge: %d, %d, %d, %d\n", leftSide[0], leftSide[1], leftSide[2], leftSide[3]);
    printf("People on the right side of the bridge: %d, %d, %d, %d\n",rightSide[0], rightSide[1], rightSide[2], rightSide[3]);
    two_finished = true;
    didComeBack = false;
}
// the function move the person back to the left of the bridge
proctype moveToLeft() {
    // the value of the person who comes back to the left side
    byte moveBack;
    if
     :: rightSide[0] != 0 -> moveBack = rightSide[0]; rightSide[0] = 0; leftSide[0] = moveBack; time = time + 1
     :: rightSide[1] != 0 -> moveBack = rightSide[1]; rightSide[1] = 0; leftSide[1] = moveBack; time = time + 2
     :: rightSide[2] != 0 -> moveBack = rightSide[2]; rightSide[2] = 0; leftSide[2] = moveBack; time = time + 5
     :: rightSide[3] != 0 -> moveBack = rightSide[3]; rightSide[3] = 0; leftSide[3] = moveBack; time = time + 8
    fi; 
    // print out the result
    printf("People on the left side of the bridge: %d, %d, %d, %d\n", leftSide[0], leftSide[1], leftSide[2], leftSide[3]);
    printf("People on the right side of the bridge: %d, %d, %d, %d\n",rightSide[0], rightSide[1], rightSide[2], rightSide[3]);
    didComeBack = true;
    two_finished = false;
}

// the main function
init {
    // first person with the value 1 in the first index
    leftSide[0] = 1;
    // second person with the value 2 in the second index
    leftSide[1] = 2;
    // third person with the value 3 in the third index
    leftSide[2] = 3;
    // fourth person with the value 4 in the fourth index
    leftSide[3] = 4;
    // there is no one on the right side
    rightSide[0] = 0;
    rightSide[1] = 0;
    rightSide[2] = 0;
    rightSide[3] = 0;
    two_finished = false;
    didComeBack = false;
    finished = false;
    time = 0;
    // print out the first result
    printf("People on the left side of the bridge: %d, %d, %d, %d\n", leftSide[0], leftSide[1], leftSide[2], leftSide[3]);
    printf("People on the right side of the bridge: %d, %d, %d, %d\n",rightSide[0], rightSide[1], rightSide[2], rightSide[3]);
    run moveToRight();
    do
     :: two_finished == false && didComeBack == true -> didComeBack = false; 
      if
       :: rightSide[0] == 1 && rightSide[1] == 2 && rightSide[2] == 3 && rightSide[3] == 4 -> finished = true; break;
       :: else -> run moveToRight();
      fi;
     :: didComeBack == false && two_finished == true -> two_finished = false; 
      if
       :: rightSide[0] == 1 && rightSide[1] == 2 && rightSide[2] == 3 && rightSide[3] == 4 -> finished = true; break;
       :: else ->  run moveToLeft();
      fi;
    od
}

// No error if the time will always be more than 15 minutes, otherwise returns error
never{
    do
     :: finished == true && time <= 15 -> break 
     :: else
    od
}