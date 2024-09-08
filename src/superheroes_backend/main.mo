import Nat32 "mo:base/Nat32";
import Trie "mo:base/Trie"; //key value hashmap
import Option "mo:base/Option"; //typesafe null
import List "mo:base/List"; //singly linked list

actor Superheroes {
  /**
*Types
*/
  public type SuperheroId = Nat32;

  public type Superhero = {
    name : Text;
    superpowers : List.List<Text>;
  };

  private stable var next : SuperheroId = 0;

  private stable var superheroes : Trie.Trie<SuperheroId, Superhero> = Trie.empty();

  //create
  public func create(superhero : Superhero) : async SuperheroId {
    let id = next;
    next += 1; //increment next available id

    superheroes := Trie.replace(
      superheroes,
      key(id),
      Nat32.equal,
      ?superhero,
    ).0;

    return id;
  };

  //read
  public func read(id : SuperheroId) : async ?Superhero {
    return Trie.get(superheroes, key(id), Nat32.equal);
  };

  //update
  public func update(id : SuperheroId, superhero : Superhero) : async Bool {
    let result = Trie.find(superheroes, key(id), Nat32.equal); //find if exists
    let exists = Option.isSome(result);
    if (exists) {
      superheroes := Trie.replace(
        superheroes,
        key(id),
        Nat32.equal,
        ?superhero,
      ).0;
    };
    return exists;
  };
  
  //delete
  public func delete(id:SuperheroId): async Bool{
    let result = Trie.find(superheroes, key(id), Nat32.equal); //find if exists
    let exists = Option.isSome(result);
//🚩
    if (exists) {
      superheroes := Trie.replace(
        superheroes,
        key(id),
        Nat32.equal,
        null,
      ).0;
    };
    return exists;
  };

  //trie key from identifier
  private func key(x:SuperheroId): Trie.Key<SuperheroId>{
    return {hash=x; key=x};
  };


};
