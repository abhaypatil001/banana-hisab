import 'package:flutter/material.dart';
import '../models/party.dart';
import '../services/database_service.dart';
import 'dart:math';

class PartyProvider with ChangeNotifier {
  final DatabaseService _db = DatabaseService();
  List<Party> _parties = [];
  bool _isLoading = false;

  List<Party> get parties => _parties;
  bool get isLoading => _isLoading;

  Future<void> loadParties() async {
    _isLoading = true;
    notifyListeners();
    
    _parties = await _db.getParties();
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addParty(String name, String? phone) async {
    final party = Party(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      phone: phone,
      colorIndex: Random().nextInt(8),
      createdAt: DateTime.now(),
    );
    
    await _db.insertParty(party);
    await loadParties();
  }

  Future<Party?> getOrCreateParty(String name) async {
    Party? party = await _db.getPartyByName(name);
    
    if (party == null) {
      await addParty(name, null);
      party = await _db.getPartyByName(name);
    }
    
    return party;
  }

  List<Party> searchParties(String query) {
    if (query.isEmpty) return _parties;
    
    return _parties.where((p) => 
      p.name.toLowerCase().contains(query.toLowerCase()) ||
      (p.phone?.contains(query) ?? false)
    ).toList();
  }
}
