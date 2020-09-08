class Solution {
  long strategy ;
  int cost ;
  int distance ;

  Solution previous ;
  Solution next ;
  Solution() {
    previous = this ;
    next = this ;
  }
  Solution(Solution t, long s, int c, int d) {
    //addBefore t
    strategy = s ;
    cost = c ;
    distance = d ;

    next = t ;
    previous = t.previous ;
    previous.next = next.previous = this ;
  }
  /*
  void remove() {
    previous.next = next ;
    next.previous = previous ;
    next = previous = this ;
  }
  */
  int dominate(int c, int d) {
    int score = 0 ;
    if (cost != c) {
      score += (cost < c) ? 1 : -1 ;
    }
    if (distance != d) {
      score += (distance > d) ? 1 : -1 ;
    }
    return score ;
  }
  String toString() {
    return "(" + cost + ", " + distance + ", " + strategy  + ")" ;
  }
}

class SolutionSet {
  Solution head ;
  SolutionSet() {
    head = new Solution() ;
  }
  void remove(Solution t) {
    t.previous.next = t.next ;
    t.next.previous = t.previous ;
    t.next = t.previous = t ;
  }
  void insert_sort(long strategy, int cost, int distance) {

    if (head.next == head) {
      new Solution(head, strategy, cost, distance) ;
    }
    else {
      Solution s = head.next ;

      while (s != head) {
        if (s.cost >= cost) break ;
        s = s.next ;
      }
      while (s != head) {
        if (s.cost > cost) break ;
        // Assumption: s.cost == cost
        if (s.distance > distance) return ;
        if (s.distance < distance) {
          s = s.next ;
          remove(s.previous) ;
        }
        else {
          s = s.next ;
        }
      }
      new Solution(s, strategy, cost, distance) ;
      while (s != head) {
        // Assumption: s.cost > cost
        if (s.distance > distance) break ;
        // Assumption: s.distance <= distance
        s = s.next ;
        remove(s.previous) ;
      }
    }
  }
  Solution closestSolution(Solution t, int cost) {
    if (t == null || t.next == t) {
      if (head.next == head || head.next.cost > cost) return null ;
      t = head.next ;
    }
    if (t.next == head) return t ;

    for (Solution s = t.next ; s != head ; s = s.next) {
      if (s.cost <= cost) continue ;
      return s.previous ;
    }
    return head.previous ;
  }
  String toString() {
    String stg = "" ;
    int i = 0 ;
    for (Solution s = head.next ; s != head ; s = s.next) {
      stg += s.toString() +"\n" ;
      i++ ;
    }
    return "(cost, shortest path length, strategy bit)\n" + stg + "\n" + "total pareto optimal solution num : " + i ;
  }
}


/*

(c1, d1) dominate (c2, d2)
if c1 <= c2 and d1 >= d2 and (c1 < c2 or d1 > d2)

solution:
(c1, d1)
(c2, d2)
(c3, d3)

assumption:
c1 < c2 < c3
d1 < d2

d1 >= d3

*/
