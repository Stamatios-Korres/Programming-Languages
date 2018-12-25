
public class Village {
	private int parent;
	private int SetSize;
	public Village(int parent){
		this.parent = parent;
		SetSize = 1;
	}
	public void SetNewSize(int newSize){
		SetSize = newSize;
	}
	public int GetSize(){
		return SetSize;
	}
	public int GetParent(){
		return parent;
	}
	public void SetParent(int Newparent){
		parent = Newparent;
	}
}
