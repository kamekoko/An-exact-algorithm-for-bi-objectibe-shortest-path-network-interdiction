int allTime = 0 ;
int repeatNum = 1 ;
long solutionCount = 0 ;

void setup() {

  //String data = "network_18.csv" ; //辺数29
  String data = "network_20.csv" ; //辺数30
  //String data = "network_25.csv" ; //辺数40
  //String data = "network_36.csv" ; //辺数60

  Network net = new Network(data) ;
  SolutionSet ps = new SolutionSet() ;

  for (int i = 1 ; i <= repeatNum ; i++) {
    solutionCount = 0 ;
    int start = millis() ;
    BranchAndBound bb = new BranchAndBound(net) ;
    ps = bb.paretoBBSearch() ;
  }
  println(ps) ;
  println("searched solution count : " + solutionCount) ;
  println("search area : " + (double)(solutionCount / (double)pow(2, net.edges.length))) ;
  println("all time       : " + allTime) ;
  println("average        : " + (double)(allTime / repeatNum)) ;

  exit() ;
}
