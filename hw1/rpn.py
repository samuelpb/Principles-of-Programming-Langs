import sys

#class to keep track of numbers in the calculator
class Stack:
    def __init__(self, size):
        self.size = size
        self.start = None
        self.curr = None

    #inner class to store values on the stack
    class Node:
        def __init__(self, value, curr):
            self.value = value
            self.prev = curr

    #adds a value to the top of the stack, and returns its value
    def push(self, value):
        a = self.Node(value, self.curr)
        self.curr = a
        self.size = self.size+1
        if self.size == 1:
            self.start = self.curr
        return self.curr.value

    #removes the top item of the stack and returns its value
    def pop(self):
        if self.size == 0 :
            return None
        value = self.curr.value
        self.curr = self.curr.prev
        self.size = self.size - 1
        return value

    #prints the top item on the stack, and 'stack is empty" if needed
    def printtop(self):
        if not self.curr:
            print('stack is empty')
            return
        print(self.curr.value)


def main():
    x = Stack(0)
    #checks each line in the input
    for line in sys.stdin:
        try:
            s = line.split()
        except EOFError:
            break
        if s[0] == '+':
            if x.size<2 :
                print('invalid operation')
                continue
            a = x.pop()
            b = x.pop()
            c = a + b
            x.push(c)
            #add the add function
        elif s[0] == '-':
            if x.size < 2:
                print('invalid operation')
                continue
            a = x.pop()
            b = x.pop()
            c = b - a
            x.push(c)
        elif s[0] == '/':
            if x.size < 2:
                print('invalid operation')
                continue
            a = x.pop()
            b = x.pop()
            if a == 0:
                print('invalid operation')
                x.push(b)
                x.push(a)
                continue
            c = b/a
            x.push(c)
        elif s[0] == '*' :
            if x.size < 2:
                print('invalid operation')
                continue
            a = x.pop()
            b = x.pop()
            c = a*b
            x.push(c)
        elif s[0] == '~':
            if x.size < 1:
                print('invalid operation')
                continue
            a = x.pop()
            c = a * -1
            x.push(c)
        else:
            try:
                num = int(s[0])
                x.push(num)
            except ValueError:
                print('invalid operation')
        x.printtop()


if __name__ == '__main__':
    main()