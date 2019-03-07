import sys


#class for the node of the tree, has a value, a right child and left child
class Node:
    def __init__(self, value, right, left):
        self.right = right
        self.left = left
        self.value = value


#function to search the tree for a value
    #returns its path, or 'x' if not found
def query (root, val):
    if not root :
        return "x"
    elif root.value == val:
        return ""
    elif root.value < val:
        a = query (root.right, val)
        if a == "x":
            return a
        else:
            return "r " + a
    else:
        a = query(root.left, val)
        if a == "x":
            return a
        else:
            return "l " + a


#function to insert a node into the tree, and if its a duplicate it returns 'x'
    #if insertion is successful, it returns 'a'
def insert(root, val):
    if val < root.value:
        if not root.left:
            a = Node(val, None, None)
            root.left = a
        else:
            if insert (root.left, val) != "x":
                return "a"
            else :
                return "x"
    elif val > root.value:
        if not root.right:
            a = Node(val, None, None)
            root.right = a
        else:
            if insert(root.right, val) != "x":
                return "a"
            else:
                return "x"
    else:
        return "x"


def main():
    root = Node(654321, None, None)
    #loops through luines checking for valid input, printing out error if needed
    for line in sys.stdin:
        x = line
        s = x.split(' ')
        if s[0] == 'i' :
            if not s[1] :
                print("invalid input")
            else :
                if root.value == 654321 :
                    root.value = int(s[1])
                else :
                    a = insert(root, int(s[1]))
                    if a == 'x':
                        print("duplicate insert")
        elif s[0] == 'q' :
            if not s[1]:
                print("invalid input")
            else:
                if int(s[1]) == root.value:
                    print("found: root")
                else:
                    if int(s[1])<root.value:
                        a = "l " + query(root.left, int(s[1]))
                    else:
                        a = "r " + query(root.right, int(s[1]))
                    if a == "l x" or a == "r x":
                        print("not found")
                    else :
                        print("found:", end=' ')
                        print(a)
        else:
            print("invalid input")
    return


if __name__ == '__main__':
    main()

