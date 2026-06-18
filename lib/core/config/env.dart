/// Configuration d'environnement de l'application.
///
/// Ce fichier centralise les valeurs globales liées au projet
/// et à l'environnement d'exécution.
///
/// Important pour l'équipe :
/// - si le backend change, on modifie l'URL ici
/// - éviter d'écrire la baseUrl directement dans les services
class Env {
  Env._();

  /// Nom de l'application
  static const String appName = 'Thielal / LifeLink';

  /// URL de base du backend Render
  ///
  /// Toutes les requêtes API passent par cette base URL.
  static const String baseUrl ='https://lifelink-backend-3bgr.onrender.com/api';
  //'https://lifelink-backend-3bgr.onrender.com/api';
  //
}
// "http://localhost:5000/api";