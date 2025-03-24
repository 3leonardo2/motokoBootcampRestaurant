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
import Types "types";

actor {
  var platillos : HashMap.HashMap<Nat, Types.Platillo> = HashMap.HashMap<Nat, Types.Platillo>(0, Nat.equal, Hash.hash);
  type Mesas = HashMap.HashMap<Nat, Types.Mesa>;
  var contadorMesa : Nat = 0;
  var nuevasMesas : Mesas = HashMap.HashMap<Nat, Types.Mesa>(0, Nat.equal, Hash.hash);

  public func addPlatillo(idPlatillo : Nat, nombre : Text, precio : Nat, descripcion : Text) : async (Nat, Nat) {
    let nuevoPlatillo : Types.Platillo = {
      idPlatillo = idPlatillo;
      nombre = nombre;
      precio = precio;
      descripcion = descripcion;
    };
    platillos.put(idPlatillo, nuevoPlatillo);
    return (idPlatillo, precio);
  };

  public func getPlatillo(idPlatillo : Nat) : async ?Types.Platillo {
    return platillos.get(idPlatillo);
  };

  public func addMesa(capacidad : Nat, ocupada : Bool) : async Nat {
    contadorMesa += 1;
    let newMesa : Types.Mesa = {
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

  public func getMesa(idMesa : Nat) : async ?Types.Mesa {
    return nuevasMesas.get(idMesa);
  };

  public func cobrarMesa(idMesa : Nat) : async Result.Result<Text, Text> {
    switch (nuevasMesas.get(idMesa)) {
      case (?mesa) {
        let totalCuenta : Nat = mesa.cuenta.total;
        ignore nuevasMesas.remove(idMesa);
        if (nuevasMesas.get(idMesa) == null) {
          return #ok("✅ Cobro procesado. Total a pagar: $" # Nat.toText(totalCuenta) # ". Mesa eliminada correctamente.");
        } else {
          return #err("⚠️ Error: No se pudo eliminar la mesa. Intente nuevamente.");
        };
      };
      case (null) {
        return #err("❌ Error: La mesa con id " # Nat.toText(idMesa) # " no existe.");
      };
    };
  };

  public func addPlatilloToMesa(idMesa : Nat, idPlatillo : Nat, cantidad : Nat) : async Result.Result<Text, Text> {
    switch (nuevasMesas.get(idMesa)) {
      case (?mesa) {
        switch (platillos.get(idPlatillo)) {
          case (?platillo) {
            let platillosNuevos = Array.freeze<Types.Platillo>(Array.init<Types.Platillo>(cantidad, platillo));
            let nuevaCuenta : Types.Pedido = {
              platillos = Array.append<Types.Platillo>(mesa.cuenta.platillos, platillosNuevos);
              total = mesa.cuenta.total + (platillo.precio * cantidad);
            };
            let mesaActualizada : Types.Mesa = {
              idMesa = mesa.idMesa;
              capacidad = mesa.capacidad;
              ocupada = true;
              cuenta = nuevaCuenta;
            };
            nuevasMesas.put(idMesa, mesaActualizada);
            return #ok(
              "✅ Se agregaron " # Nat.toText(cantidad) # " platillos de " # platillo.nombre #
              " a la mesa. Total actualizado: $" # Nat.toText(nuevaCuenta.total)
            );
          };
          case (null) {
            return #err("❌ Error: El platillo con id " # Nat.toText(idPlatillo) # " no existe.");
          };
        };
      };
      case (null) {
        return #err("❌ Error: La mesa con id " # Nat.toText(idMesa) # " no existe.");
      };
    };
  };
};
