import 'package:flutter/material.dart';
import '../modele/redacteur.dart';
import '../services/database_manager.dart';

class RedacteurInterface extends StatefulWidget {
  const RedacteurInterface({super.key});

  @override
  State<RedacteurInterface> createState() => _RedacteurInterfaceState();
}

class _RedacteurInterfaceState extends State<RedacteurInterface> {
  final DatabaseManager _databaseManager = DatabaseManager();
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  List<Redacteur> _redacteurs = [];

  @override
  void initState() {
    super.initState();
    _chargerRedacteurs();
  }

  Future<void> _chargerRedacteurs() async {
    final liste = await _databaseManager.getAllRedacteurs();
    setState(() {
      _redacteurs = liste;
    });
  }

  Future<void> _modifierRedacteur(Redacteur redacteur) async {
    final TextEditingController nomCtrl =
        TextEditingController(text: redacteur.nom);
    final TextEditingController prenomCtrl =
        TextEditingController(text: redacteur.prenom);
    final TextEditingController emailCtrl =
        TextEditingController(text: redacteur.email);

    await showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Modifier Rédacteur'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomCtrl,
                decoration: const InputDecoration(labelText: 'Nouveau Nom'),
              ),
              TextField(
                controller: prenomCtrl,
                decoration:
                    const InputDecoration(labelText: 'Nouveau Prénom'),
              ),
              TextField(
                controller: emailCtrl,
                decoration: const InputDecoration(labelText: 'Nouvel Email'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                final redacteurModifie = Redacteur(
                  id: redacteur.id,
                  nom: nomCtrl.text.trim(),
                  prenom: prenomCtrl.text.trim(),
                  email: emailCtrl.text.trim(),
                );

                await _databaseManager.updateRedacteur(redacteurModifie);
                await _chargerRedacteurs();

                if (dialogContext.mounted) {
                  Navigator.of(dialogContext).pop();
                }
              },
              child: const Text('Enregistrer'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _ajouterRedacteur() async {
    final String nom = _nomController.text.trim();
    final String prenom = _prenomController.text.trim();
    final String email = _emailController.text.trim();

    if (nom.isEmpty || prenom.isEmpty || email.isEmpty) {
      return; // TODO : afficher un message d'erreur (SnackBar)
    }

    final nouveauRedacteur = Redacteur.sansId(
      nom: nom,
      prenom: prenom,
      email: email,
    );

    await _databaseManager.insertRedacteur(nouveauRedacteur);

    _nomController.clear();
    _prenomController.clear();
    _emailController.clear();

    await _chargerRedacteurs();
  }

  Future<void> _confirmerSuppression(Redacteur redacteur) async {
    await showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Supprimer le rédacteur'),
          content: Text(
            'Voulez-vous vraiment supprimer ${redacteur.nom} ${redacteur.prenom} ?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                await _databaseManager.deleteRedacteur(redacteur.id!);
                await _chargerRedacteurs();

                if (dialogContext.mounted) {
                  Navigator.of(dialogContext).pop();
                }
              },
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Couleur magenta/rose utilisée dans la maquette du sujet.
    const Color couleurPrincipale = Color(0xFFD6006D);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: couleurPrincipale,
        foregroundColor: Colors.white,
        leading: const Icon(Icons.menu),
        title: const Text('Gestion des rédacteurs'),
        actions: const [
          Icon(Icons.search),
          SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nomController,
              decoration: const InputDecoration(labelText: 'Nom'),
            ),
            TextField(
              controller: _prenomController,
              decoration: const InputDecoration(labelText: 'Prénom'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _ajouterRedacteur,
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text('Ajouter un Rédacteur'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: couleurPrincipale,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _redacteurs.length,
                itemBuilder: (context, index) {
                  final redacteur = _redacteurs[index];
                  return Card(
                    child: ListTile(
                      title: Text('${redacteur.nom} ${redacteur.prenom}'),
                      subtitle: Text(redacteur.email),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () =>
                                _confirmerSuppression(redacteur),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit_outlined),
                            onPressed: () => _modifierRedacteur(redacteur),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}