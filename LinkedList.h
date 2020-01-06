//
//  LinkedList.h
//

// Structure representing a 
// doubly-linked list node.
typedef struct ListNode ListNode;
struct ListNode {
	int value;
	ListNode *next;
	ListNode *prev;
};


@interface LinkedList : NSObject {
@private 
	ListNode *head;
	ListNode *iterator;
	//bool reachedHead;
	//bool reachedTail;
}	

- (id)initWithHead: (int)value;
- (void)addToFront: (int)value;
- (int)getFirst;
- (int)getCurrent;
- (int)getNext;
- (int)getPrevious;

- (bool)atHead;
- (bool)atTail;

- (int)removeCurrent;

@end