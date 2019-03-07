import sys

class State() :
    def __init__ (self, name) :
        self.name = name
        self.rules = {}
        self.next = None;

#creates a state for the list and returns it
def create(name) :
    node = State(name);
    return node


#adds a symbol to a state, saying in a dictionary on the state where it points to
def addrule(head, start, end, state) :
    curr = head
    while curr.name != start :
        curr = curr.next
        if not curr:
            return 'fail'

    curr.rules[state] = end
    return ' '


#reads the instruction line and traces through the map, and checkin where it ends
def check(instructions, head, start, final) :
    curr = head
    while curr.name != start :
        curr = curr.next


    for i in list(instructions):
        try:
            next = curr.rules.get(i)
            if not next:
                return 'rejected'
        except KeyError:
            return 'rejected'

        curr = head
        while curr.name != next:
            curr = curr.next
            if not curr:
                return 'rejected'

    for i in final :
        if i == curr.name:
            return 'accepted'

    return 'rejected'


def main() :
    counter = 0
    head = State("start")
    curr = head
    symbolsDict = {}
    for line in sys.stdin :
        if line == '\n':
            continue

        #store states
        if counter==0 :
            states = line.split('\n')
            states = states[0].split(" ")
            if states[0] != "states:":
                print('invalid input1')
                return
            for i in states:
                if i == "states:" :
                    continue
                curr.next = create(i)
                curr = curr.next
            counter = counter+1

        #store symbols
        elif counter == 1:
            symbols = line.split('\n')
            symbols = symbols[0].split(' ')
            if symbols[0] != "symbols:":
                print('invalid input2')
                return
            for i in symbols :
                if i == "symbols:":
                    continue
                symbolsDict[i] = 1;
            counter = counter +1

        #check for beginning of rules
        elif counter==2 and line != "begin_rules\n":
            print('invalid input3')
            return
        elif counter == 2:
           counter = 3

        #store rules
        elif counter == 3 and line!= 'end_rules\n':
            rules = line.split('\n')
            rules = rules[0].split(" ")
            if addrule(head.next, rules[0], rules[2], rules[4]) == 'fail' :
                print('invalid input')
                return
        elif counter == 3:
            counter = 4

        #store start
        elif counter == 4:
            start = line.split("\n")
            start = start[0].split(' ')
            counter = counter +1
            if start[0] != 'start:':
                print('invalid input4')
            start = start[1]

        #store final
        elif counter == 5:
            final = line.split('\n')
            final = final[0].split(' ')
            counter = counter +1
            if final[0] != 'final:':
                print('invalid input5')

        elif counter == 6:
            instructions = line.split('\n')
            print(check(instructions[0], head.next, start, final))


    if counter == 3:
        print('invalid input6')
        return




if __name__ == '__main__' :
    main()



#make a map of nodes and use the rules to point the nodes to each other
#test the rules by traversing from start and seeing where you end