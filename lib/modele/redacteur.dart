class Redacteur {
  final int? id;
  final String nom;
  final String prenom;
  final String email;

  // TODO 1 : constructeur complet (avec id requis)
  const Redacteur({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.email,
  });

  // TODO 2 : constructeur sansId (id = null)
  const Redacteur.sansId({
    required this.nom,
    required this.prenom,
    required this.email,
  }) : id = null;

  // TODO 3 : toMap() -> Map<String, dynamic>
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'email': email,
    };
  }

  // TODO 4 : fromMap(Map) -> Redacteur (factory)
  factory Redacteur.fromMap(Map<String, dynamic> map) {
    return Redacteur(
      id: map['id'] as int?,
      nom: map['nom'] as String,
      prenom: map['prenom'] as String,
      email: map['email'] as String,
    );
  }
}