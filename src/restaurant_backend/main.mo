import Text "mo:base/Text";
import HashMap "mo:base/HashMap";
import Hash "mo:base/Hash";
import Nat "mo:base/Nat";
import Principal "mo:base/Principal";
import Result "mo:base/Result";
import Stack "mo:base/Stack";
import List "mo:base/List";
import Array "mo:base/Array";
import Map "mo:map/Map";
import { phash } "mo:map/Map";

actor {

  type Platillo =  {
    idPlatillo : Nat;
    nombre : Text;
    precio : Nat;
    descripcion : Text;
  };
  var platillos : HashMap.HashMap<Nat, Platillo> = HashMap.HashMap<Nat, Platillo>(0, Nat.equal, Hash.hash);
  type Pedido = {
    platillos : [Platillo];
    total : Nat;
  };

  public func addPlatillo(idPlatillo : Nat, nombre : Text, precio : Nat, descripcion : Text) : async (Nat, Nat) {
    let nuevoPlatillo : Platillo = {
      idPlatillo = idPlatillo;
      nombre = nombre;
      precio = precio;
      descripcion = descripcion;
    };
    platillos.put(idPlatillo, nuevoPlatillo);
    return (idPlatillo, precio);
  };

  public func getPlatillo(idPlatillo : Nat) : async ?Platillo {
    return platillos.get(idPlatillo);
  };

  type Mesa = {
    idMesa : Nat;
    capacidad : Nat;
    ocupada : Bool;
    cuenta : Pedido;
  };
  
  type Mesas = HashMap.HashMap<Nat, Mesa>;

  var contadorMesa : Nat = 0;
  var nuevasMesas : Mesas = HashMap.HashMap<Nat, Mesa>(0, Nat.equal, Hash.hash);

  public func addMesa(capacidad : Nat, ocupada : Bool) : async Nat {
    contadorMesa += 1;
    let newMesa : Mesa = {
      idMesa = contadorMesa;
      capacidad = capacidad;
      ocupada = ocupada;
      cuenta = {
        platillos = [];
        total = 0;
      };
    };
    nuevasMesas.put(contadorMesa, newMesa);
    return contadorMesa;
  };
  
  public func getMesa(idMesa : Nat) : async ?Mesa {
    return nuevasMesas.get(idMesa);
  };

  public func addCuenta(): async Nat{
    
  }
};
