#include <stddef.h>
#include "ll_cycle.h"

int ll_has_cycle(node *head) {
    /* TODO: Implement ll_has_cycle */
    if (head == NULL || head->next == NULL || head->next->next == NULL) {
        return 0;
    }
    node *slow = head->next;
    node *fast = head->next->next;
    while (fast != NULL && fast->next != NULL && fast->next->next != NULL) {
        if (slow == fast) {
            return 1;
        }
        slow = slow->next;
        fast = fast->next->next;
    }
    return 0;
}
