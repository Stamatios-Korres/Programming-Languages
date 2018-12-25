public class UnionFind {
	private int Size;
	private Village[] A; // Village represents one village and it is has parent/size of set
	private int DisjointsSets;
	public int getSize(){
		return Size;
	}
	public UnionFind(int Size){
		this.Size = Size;
		DisjointsSets = Size; // At the begining every village is separate
		this.A = new Village[Size];
		for(int i=0;i<Size;i++){
			A[i] = new Village(i);
		}
	}
	public Village Find(int x){
		if(A[x].GetParent()!=x){
			Village y = Find(A[x].GetParent());
			A[x].SetParent(y.GetParent());
			A[x].SetNewSize(y.GetSize());
			
		}
		return A[x];
	}
	public int Result(){
		return DisjointsSets;
	}
	
	public void Union(int x,int y){
		//x,y are the representatives of the particular set
		Village SetA = Find(x);
		Village SetB = Find(y);
		if(SetA.GetParent() == SetB.GetParent()){
			return;
		}
		if(SetA.GetSize() < SetB.GetSize()){
			//A is beeing below tree B
			A[SetA.GetParent()].SetParent(SetB.GetParent());
			DisjointsSets--;
		}
		else if(SetB.GetSize() < SetA.GetSize()){
			//B is beeing below tree A
			DisjointsSets--;
			A[SetB.GetParent()].SetParent(SetA.GetParent());
		}
		else{
			DisjointsSets--;
			//By convension B is set Below A
			A[SetB.GetParent()].SetParent(SetA.GetParent());
			A[SetA.GetParent()].SetNewSize(SetA.GetSize() + 1);
		}
	}
	
	public void printArray(){
		for(int i=0;i<A.length;i++){	
			int j = i+1;
			System.out.println("Village with number " + j);
			System.out.print("His parent is: ");
			System.out.println(A[i].GetParent()+1);
			System.out.print("Size of set: ");
			System.out.println(A[i].GetSize()+1);
		}
	}
}
