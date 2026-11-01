// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Seed';

  @override
  String get appTagline => 'Cultiva tus hábitos sostenibles';

  @override
  String get navHome => 'Inicio';

  @override
  String get navProgress => 'Progreso';

  @override
  String get navLogAction => 'Acción';

  @override
  String get navMascot => 'Mascota';

  @override
  String get navExplore => 'Explorar';

  @override
  String get navProfile => 'Perfil';

  @override
  String get navSettings => 'Ajustes';

  @override
  String get authLogin => 'Iniciar sesión';

  @override
  String get authRegister => 'Registrarse';

  @override
  String get authLogout => 'Cerrar sesión';

  @override
  String get authEmail => 'Correo electrónico';

  @override
  String get authPassword => 'Contraseña';

  @override
  String get authShowPassword => 'Mostrar contraseña';

  @override
  String get authHidePassword => 'Ocultar contraseña';

  @override
  String get authConfirmPassword => 'Confirmar contraseña';

  @override
  String get authForgotPassword => '¿Has olvidado tu contraseña?';

  @override
  String get authContinueWithGoogle => 'Continuar con Google';

  @override
  String get authContinueWithApple => 'Continuar con Apple';

  @override
  String get authOrDivider => 'o';

  @override
  String homeWelcome(String name) {
    return '¡Hola de nuevo, $name!';
  }

  @override
  String get homeLogAction => 'Registrar acción';

  @override
  String get homeRecentActions => 'Acciones recientes';

  @override
  String get homeNoActions =>
      'Aún no hay acciones registradas. ¡Empieza tu aventura!';

  @override
  String get actionLogTitle => 'Registrar acción';

  @override
  String get actionSearchHint => 'Buscar acciones...';

  @override
  String actionLogged(int points) {
    return '¡Acción registrada! Has ganado $points puntos';
  }

  @override
  String get noActionsFound => 'No se han encontrado acciones';

  @override
  String get actionHistoryTitle => 'Historial de acciones';

  @override
  String get today => 'Hoy';

  @override
  String get yesterday => 'Ayer';

  @override
  String get addNoteOptional => 'Añadir una nota (opcional)';

  @override
  String get noteHint => 'Ej.: He llevado mi propia bolsa a la tienda';

  @override
  String pointsLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count puntos',
      one: '$count punto',
    );
    return '$_temp0';
  }

  @override
  String levelLabel(int level) {
    return 'Nivel $level';
  }

  @override
  String stageWithLevel(String stage, int level) {
    return '$stage (Nivel $level)';
  }

  @override
  String streakLabel(int days) {
    return 'Racha de $days días';
  }

  @override
  String co2Saved(String amount) {
    return '$amount CO₂ ahorrado';
  }

  @override
  String mascotName(String name) {
    return '$name';
  }

  @override
  String get mascotRename => 'Cambiar nombre';

  @override
  String mascotEvolution(int stage) {
    return 'Etapa de evolución $stage';
  }

  @override
  String get mascotSelectionTitle => 'Elige a tu compañero';

  @override
  String get mascotSelectionSubtitle =>
      '¡Este pequeño amigo crecerá contigo en tu camino hacia la sostenibilidad!';

  @override
  String get mascotNameLabel => 'Dale un nombre a tu compañero';

  @override
  String get mascotNameHint => 'Ej.: Brotecito, Hojita, Capullo...';

  @override
  String get mascotNameRequired => 'Introduce un nombre';

  @override
  String get mascotNameTooLong =>
      'El nombre no puede superar los 20 caracteres';

  @override
  String get mascotSelectionConfirm => '¡Crezcamos juntos!';

  @override
  String get evolutionTitle => '¡Evolución!';

  @override
  String get evolutionSubtitle => '¡Tu compañero se ha vuelto más fuerte!';

  @override
  String get evolutionContinue => '¡Increíble!';

  @override
  String get profileTitle => 'Perfil';

  @override
  String get profileStats => 'Estadísticas';

  @override
  String get profileTotalActions => 'Total de acciones';

  @override
  String get profileTotalCO2 => 'Total de CO₂ ahorrado';

  @override
  String get profileMemberSince => 'Miembro desde';

  @override
  String profileMemberSinceDate(String date) {
    return 'Miembro desde $date';
  }

  @override
  String get profileCurrentStreak => 'Racha actual';

  @override
  String get profileLongestStreak => 'Racha más larga';

  @override
  String profileNextLevel(int points) {
    return '$points pts para el siguiente nivel';
  }

  @override
  String profileDaysActive(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days días',
      one: '$days día',
    );
    return '$_temp0';
  }

  @override
  String profileEvolutionStage(int stage) {
    return 'Etapa de evolución $stage';
  }

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get settingsNotifications => 'Notificaciones';

  @override
  String get settingsReminderTime => 'Recordatorio diario';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsThemeSystem => 'Sistema';

  @override
  String get settingsThemeLight => 'Claro';

  @override
  String get settingsThemeDark => 'Oscuro';

  @override
  String get settingsAccount => 'Cuenta';

  @override
  String get settingsSubscription => 'Suscripción';

  @override
  String get settingsAbout => 'Acerca de';

  @override
  String get settingsPrivacy => 'Política de privacidad';

  @override
  String get settingsTerms => 'Términos de servicio';

  @override
  String get subscriptionFree => 'Gratis';

  @override
  String get subscriptionPremium => 'Premium';

  @override
  String get subscriptionUpgrade => 'Pasar a Premium';

  @override
  String get categoryRecycling => 'Reciclaje';

  @override
  String get categoryTransport => 'Transporte';

  @override
  String get categoryFood => 'Alimentación';

  @override
  String get categoryEnergy => 'Energía';

  @override
  String get categoryConsumption => 'Consumo';

  @override
  String get categoryWater => 'Agua';

  @override
  String get categoryCommunity => 'Comunidad';

  @override
  String get categoryAdvocacy => 'Activismo';

  @override
  String get categoryLearning => 'Aprendizaje';

  @override
  String get errorGeneric => 'Algo ha ido mal. Inténtalo de nuevo.';

  @override
  String get errorNetwork => 'Sin conexión a internet.';

  @override
  String get errorAuth => 'Error de autenticación. Inténtalo de nuevo.';

  @override
  String get errorOpenLink => 'No se ha podido abrir el enlace.';

  @override
  String get errorActionTooSoon => 'Espera unos segundos entre acciones.';

  @override
  String get errorActionRejected =>
      'No se ha podido registrar la acción. Comprueba que la fecha y la hora del dispositivo se ajustan automáticamente y vuelve a intentarlo.';

  @override
  String get errorLogActionOffline =>
      'No se puede registrar una acción sin conexión. Comprueba tu conexión e inténtalo de nuevo.';

  @override
  String get errorAuthEmailInUse =>
      'Ya existe una cuenta con este correo electrónico.';

  @override
  String get errorAuthInvalidEmail => 'Introduce un correo electrónico válido.';

  @override
  String get errorAuthOperationNotAllowed =>
      'Este método de inicio de sesión no está activado. Ponte en contacto con el soporte.';

  @override
  String get errorAuthWeakPassword =>
      'La contraseña es demasiado débil. Usa al menos 6 caracteres.';

  @override
  String get errorAuthUserDisabled =>
      'Esta cuenta ha sido desactivada. Ponte en contacto con el soporte.';

  @override
  String get errorAuthInvalidCredentials =>
      'Correo o contraseña incorrectos. Inténtalo de nuevo.';

  @override
  String get errorAuthTooManyRequests =>
      'Demasiados intentos. Espera un momento e inténtalo de nuevo.';

  @override
  String get errorAuthNetwork =>
      'Error de red. Comprueba tu conexión a internet.';

  @override
  String get errorAuthSignInCancelled => 'Se ha cancelado el inicio de sesión.';

  @override
  String get errorAuthSignInOffline =>
      'No se puede iniciar sesión sin conexión. Comprueba tu conexión e inténtalo de nuevo.';

  @override
  String get errorAuthAccountExistsWithDifferentCredential =>
      'Ya existe una cuenta con este correo que usa otro método de inicio de sesión.';

  @override
  String get errorAuthLinkExpired =>
      'Este enlace ha caducado. Solicita uno nuevo.';

  @override
  String get errorAuthLinkInvalid =>
      'Este enlace no es válido. Solicita uno nuevo.';

  @override
  String get buttonSave => 'Guardar';

  @override
  String get buttonCancel => 'Cancelar';

  @override
  String get buttonConfirm => 'Confirmar';

  @override
  String get buttonClose => 'Cerrar';

  @override
  String get buttonRetry => 'Reintentar';

  @override
  String get buttonContinue => 'Continuar';

  @override
  String get progressTitle => 'Progreso';

  @override
  String get progressGoalsToday => 'metas hoy';

  @override
  String get progressGoalReached => '¡Meta diaria alcanzada!';

  @override
  String get progressSunEmptyHint =>
      '¡Cumple tus metas para que crezca tu sol!';

  @override
  String get progressSetDailyGoal => 'Establece tu meta diaria';

  @override
  String get progressSetDailyGoalSubtitle =>
      '¿Cuántas acciones ecológicas quieres completar cada día?';

  @override
  String get progressStartJourney => 'Empezar mi camino';

  @override
  String get progressTargetDescriptionEasy =>
      'Un comienzo tranquilo. ¡Perfecto para principiantes!';

  @override
  String get progressTargetDescriptionModerate =>
      'Un desafío equilibrado, recomendado para la mayoría.';

  @override
  String get progressTargetDescriptionChallenge =>
      '¡Ambicioso! Te has propuesto marcar la diferencia.';

  @override
  String get progressTargetDescriptionExpert =>
      'Nivel experto. ¡La sostenibilidad es lo tuyo!';

  @override
  String get languageSettingsTitle => 'Idioma';

  @override
  String get languageSettingsDescription =>
      'Elige tu idioma preferido. La app se actualizará al instante.';

  @override
  String get languageSettingsNote =>
      'Parte del contenido de la biblioteca de acciones puede seguir en su idioma original.';

  @override
  String get languageNameEnglish => 'Inglés';

  @override
  String get languageNameSpanish => 'Español';

  @override
  String get languageNameJapanese => 'Japonés';

  @override
  String get languagePickerTitle => 'Elige tu idioma';

  @override
  String get languagePickerHint =>
      'Puedes cambiarlo cuando quieras en Ajustes.';

  @override
  String languageCurrentLabel(String language) {
    return 'Idioma: $language';
  }

  @override
  String settingsNotificationsSubtitle(int count) {
    return '$count recordatorios activados';
  }

  @override
  String get settingsNotificationsOff =>
      'Las notificaciones están desactivadas';

  @override
  String settingsLanguageSubtitle(String language) {
    return '$language';
  }

  @override
  String get settingsAccountSubtitle => 'Correo, contraseña, eliminar cuenta';

  @override
  String get settingsAboutSubtitle => 'Versión, licencias, contacto';

  @override
  String get accountSettingsTitle => 'Cuenta';

  @override
  String get accountSettingsEmail => 'Correo electrónico';

  @override
  String get accountSettingsChangeEmail => 'Cambiar correo';

  @override
  String get accountSettingsChangePassword => 'Cambiar contraseña';

  @override
  String get accountSettingsDeleteAccount => 'Eliminar cuenta';

  @override
  String get accountSettingsDeleteAccountWarning =>
      'Esta acción no se puede deshacer. Todos tus datos se eliminarán de forma permanente.';

  @override
  String get accountSettingsDeleteConfirmTitle => '¿Eliminar cuenta?';

  @override
  String get accountSettingsDeleteConfirmMessage =>
      '¿Seguro que quieres eliminar tu cuenta? Se eliminarán de forma permanente todos tus datos, incluidos tu mascota, tu historial de acciones y tu progreso.';

  @override
  String get accountSettingsDeleteConfirmButton => 'Eliminar mi cuenta';

  @override
  String get accountSettingsCurrentEmail => 'Correo actual';

  @override
  String get accountSettingsNewEmail => 'Nuevo correo';

  @override
  String get accountSettingsCurrentPassword => 'Contraseña actual';

  @override
  String get accountSettingsNewPassword => 'Nueva contraseña';

  @override
  String get accountSettingsConfirmNewPassword => 'Confirmar nueva contraseña';

  @override
  String get accountSettingsPasswordMismatch => 'Las contraseñas no coinciden';

  @override
  String get accountSettingsEmailUpdated => 'Correo actualizado correctamente';

  @override
  String get accountSettingsPasswordUpdated =>
      'Contraseña actualizada correctamente';

  @override
  String get accountSettingsReauthRequired =>
      'Vuelve a introducir tu contraseña para continuar';

  @override
  String get accountSettingsProfile => 'Perfil';

  @override
  String get accountSettingsDisplayName => 'Nombre para mostrar';

  @override
  String get accountSettingsNotSet => 'Sin establecer';

  @override
  String get accountSettingsDisplayNameUpdated =>
      'Nombre actualizado correctamente';

  @override
  String get accountSettingsDisplayNameRequired => 'Introduce un nombre';

  @override
  String get aboutSettingsTitle => 'Acerca de';

  @override
  String get aboutSettingsVersion => 'Versión';

  @override
  String get aboutSettingsLicenses => 'Licencias de código abierto';

  @override
  String get aboutSettingsPrivacy => 'Política de privacidad';

  @override
  String get aboutSettingsTerms => 'Términos de servicio';

  @override
  String get streakMilestoneTitle => '¡Increíble!';

  @override
  String streakMilestoneWeeks(int count) {
    return '¡Racha de $count semanas!';
  }

  @override
  String streakMilestoneDays(int count) {
    return '¡Has registrado acciones durante $count días seguidos!';
  }

  @override
  String get streakMilestoneKeepGoing =>
      '¡Sigue así, lo estás haciendo genial!';

  @override
  String get streakMilestoneContinue => 'Continuar';

  @override
  String get streakBrokenTitle => 'Racha interrumpida';

  @override
  String get streakBrokenMessage =>
      '¡No te preocupes! Empieza una nueva racha hoy.';

  @override
  String streakBrokenPrevious(int count) {
    return 'Racha anterior: $count días';
  }

  @override
  String get streakBrokenStartNew => 'Empezar una nueva racha';

  @override
  String get sortLabel => 'Ordenar';

  @override
  String sortButtonTooltip(String option) {
    return 'Ordenar: $option';
  }

  @override
  String get sortShuffle => 'Aleatorio';

  @override
  String get sortAlphabeticalAZ => 'Nombre (A-Z)';

  @override
  String get sortAlphabeticalZA => 'Nombre (Z-A)';

  @override
  String get sortCo2HighToLow => 'CO₂ (de mayor a menor)';

  @override
  String get sortCo2LowToHigh => 'CO₂ (de menor a mayor)';

  @override
  String get sortPointsHighToLow => 'Puntos (de mayor a menor)';

  @override
  String get sortPointsLowToHigh => 'Puntos (de menor a mayor)';

  @override
  String get filterBySDG => 'Filtrar por ODS';

  @override
  String get allCategories => 'Todos';

  @override
  String co2PerAction(Object amount) {
    return '${amount}g CO₂';
  }

  @override
  String get sdgYourImpact => 'Tu impacto';

  @override
  String sdgActionsLogged(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count acciones registradas',
      one: '$count acción registrada',
    );
    return '$_temp0';
  }

  @override
  String sdgCo2SavedForGoal(String amount) {
    return '$amount CO₂ ahorrado para este objetivo';
  }

  @override
  String get sdgRelatedActions => 'Acciones relacionadas';

  @override
  String get sdgViewAllActions => 'Ver todo';

  @override
  String get sdgResources => 'Recursos';

  @override
  String get sdgLearnOnlyExplanation =>
      'Este objetivo aborda problemas sistémicos que requieren acción colectiva. Aunque no puedes registrar acciones diarias directamente, aprender sobre él te ayuda a entender el panorama completo y encontrar formas de contribuir.';

  @override
  String get sdgWaysToContribute => 'Formas de contribuir';

  @override
  String get sdgNoActionsYet =>
      'Aún no hay acciones registradas para este objetivo';

  @override
  String get learnOnlyBadge => 'Aprender';

  @override
  String get learnOnlyTitle => 'Conoce esta acción';

  @override
  String get learnOnlyDescription =>
      'Esta acción apoya objetivos de sostenibilidad más amplios. Aunque no se puede registrar directamente, aprender sobre ella te ayuda a entender el panorama completo.';

  @override
  String get learnOnlyRelatedSdgs => 'Objetivos relacionados';

  @override
  String get learnOnlyDismiss => 'Entendido';

  @override
  String get settingsAnalytics => 'Privacidad';

  @override
  String get settingsAnalyticsSubtitle =>
      'Ayuda a mejorar Seed compartiendo datos de uso anónimos';

  @override
  String get privacyPolicyTitle => 'Política de privacidad';

  @override
  String get termsOfServiceTitle => 'Términos de servicio';

  @override
  String legalLastUpdated(String date) {
    return 'Última actualización: $date';
  }

  @override
  String get eggDiscoveryTitle => '¡Un huevo misterioso!';

  @override
  String eggDiscoveryMessage(String mascotName) {
    return '¡Esta noche ha aparecido un huevo misterioso junto a $mascotName!';
  }

  @override
  String get eggDiscoverySubtitle =>
      'Registra acciones todos los días durante 30 días para que eclosione.';

  @override
  String get eggDiscoveryDismiss => '¡Qué emocionante!';

  @override
  String get eggHatchingTitle => '¡Está eclosionando!';

  @override
  String get eggHatchingNamePrompt => 'Dale un nombre a tu nuevo compañero';

  @override
  String get eggHatchingConfirm => '¡Bienvenido!';

  @override
  String eggProgressLabel(int current, int total) {
    return 'Día $current/$total';
  }

  @override
  String get mascotCollectionTitle => 'Mis mascotas';

  @override
  String get mascotSwitchConfirm => '¿Cambiar mascota?';

  @override
  String mascotSwitchConfirmBody(String name) {
    return '¿Cambiar a $name?';
  }

  @override
  String get switchMascotButton => 'Cambiar';

  @override
  String get actionScienceTooltip => 'Acerca de esta acción';

  @override
  String get maxEvolutionTitle => '¡Evolución máxima!';

  @override
  String get maxEvolutionSubtitle =>
      '¡Tu compañero ha alcanzado su máximo potencial!';

  @override
  String get maxEvolutionEggHint =>
      '¡Cuida tu huevo para descubrir un nuevo compañero!';

  @override
  String get sdgAboutGoal => 'Acerca de este objetivo';

  @override
  String get sdgViewTargets => 'Ver metas';

  @override
  String get sdgTargetsTitle => 'Metas de la ONU';

  @override
  String get notifSettingsTitle => 'Ajustes de notificaciones';

  @override
  String get notifSectionNotifications => 'Notificaciones';

  @override
  String get notifEnableTitle => 'Activar notificaciones';

  @override
  String get notifEnableSubtitle =>
      'Recibe recordatorios diarios para registrar acciones';

  @override
  String get notifSmartTitle => 'Recordatorios inteligentes';

  @override
  String get notifSmartOnlyTitle => 'Recordar solo si hoy no hay acciones';

  @override
  String get notifSmartOnlySubtitle =>
      'Omitir los recordatorios los días en que ya hayas registrado algo';

  @override
  String get notifSmartDescription =>
      'Cuando está activado, los recordatorios solo aparecerán si no has registrado acciones sostenibles ese día.';

  @override
  String get notifReminderTimesTitle => 'Horas de recordatorio';

  @override
  String get notifNoReminders => 'Sin recordatorios configurados';

  @override
  String get notifAddReminder => 'Añade un recordatorio para recibir avisos';

  @override
  String get notifAddReminderTime => 'Añadir hora de recordatorio';

  @override
  String get notifMaxReminders => 'Máximo 5 recordatorios';

  @override
  String get notifEditTime => 'Editar hora del recordatorio';

  @override
  String get notifSelectTime => 'Seleccionar hora del recordatorio';

  @override
  String get notifLabelTitle => 'Etiqueta del recordatorio';

  @override
  String get notifLabelHint => 'Ej.: Por la mañana, Al salir del trabajo...';

  @override
  String get notifLabelOptional => 'Etiqueta (opcional)';

  @override
  String get notifDeleteTitle => '¿Eliminar recordatorio?';

  @override
  String notifDeleteMessage(String time) {
    return '¿Eliminar el recordatorio de las $time?';
  }

  @override
  String get notifAdd => 'Añadir';

  @override
  String get settingsPreferences => 'Preferencias';

  @override
  String settingsVersionFormat(String version) {
    return 'Versión $version';
  }

  @override
  String get settingsNoReminders => 'Sin recordatorios configurados';

  @override
  String settingsRemindersCount(int count) {
    return '$count recordatorios configurados';
  }

  @override
  String get settingsOneReminder => '1 recordatorio configurado';

  @override
  String get settingsTapToAddReminders => 'Toca para añadir recordatorios';

  @override
  String get settingsAllRemindersDisabled =>
      'Todos los recordatorios desactivados';

  @override
  String settingsRemindersPlusMore(String time, int count) {
    return '$time + $count más';
  }

  @override
  String get settingsErrorLoading => 'Error al cargar los ajustes';

  @override
  String get settingsSupport => 'Soporte';

  @override
  String get settingsFeedback => 'Enviar comentarios';

  @override
  String get settingsFeedbackSubtitle =>
      'Informa de un error o cuéntanos tu opinión';

  @override
  String get aboutLegal => 'Legal';

  @override
  String get aboutFooterSdg =>
      'Seed ayuda a registrar acciones sostenibles alineadas con los Objetivos de Desarrollo Sostenible de la ONU.';

  @override
  String get aboutFooterMade => 'Hecho con cariño por nuestro planeta.';

  @override
  String get aboutSdgIconsCredit => 'Iconos de los ODS: Naciones Unidas';

  @override
  String get aboutSubtitleTracker =>
      'Seed - Seguimiento de hábitos sostenibles';

  @override
  String get feedbackTitle => 'Enviar comentarios';

  @override
  String get feedbackCategoryLabel => 'Categoría';

  @override
  String get feedbackCategoryBug => 'Informe de error';

  @override
  String get feedbackCategoryFeature => 'Sugerencia de función';

  @override
  String get feedbackCategoryGeneral => 'Comentarios generales';

  @override
  String get feedbackDescriptionLabel => 'Escribe tu comentario';

  @override
  String get feedbackDescriptionHint => 'Cuéntanos lo que piensas...';

  @override
  String get feedbackMetadataNote =>
      'Para ayudarnos a investigar, se incluye esta información: versión de la app, dispositivo y sistema operativo, idioma y tu ID de cuenta.';

  @override
  String feedbackMetaAppVersion(String version) {
    return 'App v$version';
  }

  @override
  String get feedbackSubmit => 'Enviar comentarios';

  @override
  String get feedbackThanks => '¡Gracias por tus comentarios!';

  @override
  String get feedbackMailFailed =>
      'No se ha podido abrir tu app de correo. Inténtalo de nuevo.';

  @override
  String get mascotEvolutionTimeline => 'Etapas de evolución';

  @override
  String get mascotNextEvolution => 'Próxima evolución';

  @override
  String get mascotStatsTitle => 'Nuestra historia';

  @override
  String get mascotStatBirthday => 'Cumpleaños';

  @override
  String get mascotStatDaysTogether => 'Días juntos';

  @override
  String get mascotStatCo2Together => 'CO₂ ahorrado juntos';

  @override
  String mascotLevelShort(int level) {
    return 'Nv $level';
  }

  @override
  String mascotLevelsToGo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count niveles restantes',
      one: '$count nivel restante',
    );
    return '$_temp0';
  }

  @override
  String mascotLevelProgress(int current, int max) {
    return 'Nivel $current / $max';
  }

  @override
  String get homeExploreGoals => 'Descubre los ODS';

  @override
  String get homeExploreGoalsSubtitle =>
      'Toca para conocer los Objetivos de Desarrollo Sostenible de la ONU';

  @override
  String get homeLearnMore => 'Más información en UN.org';

  @override
  String get homePoints => 'Puntos';

  @override
  String get myGoalTitle => 'Mi meta';

  @override
  String get myGoalEmptyPrompt =>
      'Toca para establecer tu meta de sostenibilidad';

  @override
  String get myGoalUpdated => 'Meta actualizada correctamente';

  @override
  String get goalPickerTitle => 'Elige tu meta';

  @override
  String get goalPickerCustomOption => 'Escribe la tuya';

  @override
  String get goalPickerCustomHint => 'Mi meta es...';

  @override
  String get personalGoalReduceFlights =>
      'Reducir los vuelos de larga distancia';

  @override
  String get personalGoalPlantBased => 'Comer más platos vegetales';

  @override
  String get personalGoalLessPlastic => 'Eliminar el plástico de un solo uso';

  @override
  String get personalGoalWalkBike => 'Ir a pie o en bici en vez de en coche';

  @override
  String get personalGoalLessFoodWaste => 'Tirar menos comida';

  @override
  String get personalGoalBuyLess => 'Comprar menos y reutilizar más';

  @override
  String get personalGoalInspireOthers =>
      'Animar a amigos y familiares a actuar';

  @override
  String get personalGoalSaveWorld => 'Salvar el mundo';

  @override
  String sdgGoalNumber(int number) {
    return 'Objetivo $number';
  }

  @override
  String sdgGoalNumberTitle(int number, String title) {
    return 'Objetivo $number: $title';
  }

  @override
  String get sdgProgressChart => 'Progreso mundial';

  @override
  String get sdgProgressChartHint => 'Toca para ampliar';

  @override
  String get sdgBadge => 'ODS de la ONU';

  @override
  String get buttonDelete => 'Eliminar';

  @override
  String get buttonSkip => 'Omitir';

  @override
  String get authWelcomeBack => 'Hola de nuevo';

  @override
  String get authSignInSubtitle =>
      'Inicia sesión para continuar tu camino sostenible';

  @override
  String get authSignIn => 'Iniciar sesión';

  @override
  String get authOrContinueWith => 'o continúa con';

  @override
  String get authNoAccount => '¿No tienes cuenta?';

  @override
  String get authCreateAccount => 'Crear cuenta';

  @override
  String get authCreateAccountSubtitle => 'Empieza hoy tu camino sostenible';

  @override
  String get authOrSignUpWith => 'o regístrate con';

  @override
  String get authHaveAccount => '¿Ya tienes cuenta?';

  @override
  String get authAgreePrefix => 'Acepto los ';

  @override
  String get authAgreeAnd => ' y la ';

  @override
  String get authAcceptTermsError =>
      'Debes aceptar los Términos de servicio y la Política de privacidad';

  @override
  String get authForgotPasswordTitle => 'Restablecer contraseña';

  @override
  String get authForgotPasswordHint => 'Introduce tu correo electrónico';

  @override
  String get authForgotPasswordSend => 'Enviar';

  @override
  String get authForgotPasswordSent =>
      'Si existe una cuenta con este correo, se ha enviado un enlace para restablecer la contraseña.';

  @override
  String get authVerifyEmailTitle => 'Verificar correo';

  @override
  String get authCheckEmail => 'Revisa tu correo';

  @override
  String get authVerificationSentTo =>
      'Hemos enviado un enlace de verificación a:';

  @override
  String get authVerifyInstructions =>
      'Abre el enlace del correo para verificar tu cuenta y, después, vuelve aquí y toca el botón de abajo.';

  @override
  String get authChecking => 'Verificando...';

  @override
  String get authVerifiedButton => 'Ya he verificado mi correo';

  @override
  String get authVerificationSent => '¡Correo de verificación enviado!';

  @override
  String get authResendEmail => 'Reenviar correo';

  @override
  String get authDifferentEmail => 'Usar otro correo';

  @override
  String get authEmailVerified =>
      '¡Correo verificado! ¡Te damos la bienvenida a Seed!';

  @override
  String get authEmailNotVerified =>
      'El correo aún no está verificado. Revisa tu bandeja de entrada y abre el enlace de verificación.';

  @override
  String get authValidationEmailRequired => 'Introduce tu correo';

  @override
  String get authValidationEmailInvalid => 'Introduce un correo válido';

  @override
  String get authValidationPasswordRequired => 'Introduce tu contraseña';

  @override
  String get authValidationPasswordShort =>
      'La contraseña debe tener al menos 6 caracteres';

  @override
  String get authValidationConfirmRequired => 'Confirma tu contraseña';

  @override
  String pointsAbbreviated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pts',
      one: '$count pt',
    );
    return '$_temp0';
  }

  @override
  String stageFallback(int stage) {
    return 'Etapa $stage';
  }

  @override
  String get dayDetailActions => 'Acciones';

  @override
  String get dayDetailNoActions => 'No hay acciones registradas este día';

  @override
  String get dayDetailFactLocked => 'Ningún eco-dato desbloqueado este día';

  @override
  String get ecoFactTitle => 'Eco-dato del día';

  @override
  String get ecoFactDidYouKnow => '¿Sabías que...?';

  @override
  String get ecoFactSource => 'Fuente';

  @override
  String get ecoFactLocked =>
      '¡Completa el desafío de hoy para desbloquear este dato!';

  @override
  String get ecoFactInboxTitle => 'Bandeja de entrada';

  @override
  String get ecoFactInboxEmpty =>
      'Aún no hay correo. Completa el desafío de hoy para recibir tu primer eco-dato.';

  @override
  String get ecoFactInboxLockedSubject => 'Eco-dato bloqueado';

  @override
  String get ecoFactCategoryComparison => 'Comparación';

  @override
  String get ecoFactCategoryIndividual => 'Impacto individual';

  @override
  String get ecoFactCategoryMythBuster => 'Desmontando mitos';

  @override
  String get ecoFactCategoryNatureWonder => 'Maravilla natural';

  @override
  String get ecoFactCategoryPositiveNews => 'Noticia positiva';

  @override
  String get challengeDialogTitle => 'Desafío de hoy';

  @override
  String get challengeDialogLater => 'Más tarde';

  @override
  String get challengeDialogLogAction => 'Registrar acción';

  @override
  String get challengeTabLabel => 'Desafío';

  @override
  String get challengeCompleted => '¡Completado!';

  @override
  String get challengeNotCompleted => 'Aún sin completar';

  @override
  String get challengeSeeFact => 'Ver el eco-dato de hoy';

  @override
  String get challengeOverline => 'Desafío diario';

  @override
  String challengeLogAction(String action) {
    return 'Registra «$action» para desbloquear el eco-dato de hoy';
  }

  @override
  String challengeAnyActionCounts(String category) {
    String _temp0 = intl.Intl.selectLogic(category, {
      'recycling': 'Vale cualquier acción de reciclaje',
      'transport': 'Vale cualquier acción de transporte',
      'food': 'Vale cualquier acción de alimentación',
      'energy': 'Vale cualquier acción de energía',
      'consumption': 'Vale cualquier acción de consumo',
      'water': 'Vale cualquier acción relacionada con el agua',
      'community': 'Vale cualquier acción comunitaria',
      'advocacy': 'Vale cualquier acción de activismo',
      'other': 'Vale cualquier acción de esta categoría',
    });
    return '$_temp0';
  }

  @override
  String challengeLogAnyAction(String category) {
    String _temp0 = intl.Intl.selectLogic(category, {
      'recycling':
          'Registra una acción de reciclaje para desbloquear el eco-dato de hoy',
      'transport':
          'Registra una acción de transporte para desbloquear el eco-dato de hoy',
      'food':
          'Registra una acción de alimentación para desbloquear el eco-dato de hoy',
      'energy':
          'Registra una acción de energía para desbloquear el eco-dato de hoy',
      'consumption':
          'Registra una acción de consumo para desbloquear el eco-dato de hoy',
      'water':
          'Registra una acción relacionada con el agua para desbloquear el eco-dato de hoy',
      'community':
          'Registra una acción comunitaria para desbloquear el eco-dato de hoy',
      'advocacy':
          'Registra una acción de activismo para desbloquear el eco-dato de hoy',
      'other': 'Registra una acción para desbloquear el eco-dato de hoy',
    });
    return '$_temp0';
  }

  @override
  String challengeStreakDays(int days) {
    return 'Racha de desafíos: $days días';
  }

  @override
  String challengeMultiDayProgress(int current, int target) {
    return 'Día $current de $target';
  }

  @override
  String get challengeCompletedSnackbar =>
      '¡Desafío completado! ¡Eco-dato desbloqueado!';

  @override
  String get challengesScreenTitle => 'Desafíos de varios días';

  @override
  String get challengeStart => 'Iniciar desafío';

  @override
  String get challengeStartConfirm => '¿Iniciar este desafío?';

  @override
  String get challengeActive => 'Activo';

  @override
  String get challengeCompletedBadge => 'Completado';

  @override
  String get challengeAvailable => 'Disponible';

  @override
  String get challengeAbandon => 'Abandonar';

  @override
  String get challengeAbandonConfirm =>
      '¿Abandonar este desafío? Se perderá el progreso.';

  @override
  String challengeDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days días',
      one: '$days día',
    );
    return '$_temp0';
  }

  @override
  String get challengeAnyCategory => 'Cualquier categoría';

  @override
  String get challengeLocked => 'Bloqueado';

  @override
  String get progressCalendarTab => 'Calendario';

  @override
  String get ecoDexTab => 'Eco-Dex';

  @override
  String get impactTab => 'Impacto';

  @override
  String get periodToday => 'Hoy';

  @override
  String get periodThisWeek => 'Semana';

  @override
  String get periodThisMonth => 'Mes';

  @override
  String get periodAllTime => 'Total';

  @override
  String get co2SavedToday => 'CO2 ahorrado hoy';

  @override
  String get co2SavedThisWeek => 'CO2 ahorrado esta semana';

  @override
  String get co2SavedThisMonth => 'CO2 ahorrado este mes';

  @override
  String get co2SavedAllTime => 'CO2 ahorrado en total';

  @override
  String get kgUnit => 'kg';

  @override
  String comparisonVsYesterday(String percent) {
    return '$percent% frente a ayer';
  }

  @override
  String comparisonVsLastWeek(String percent) {
    return '$percent% frente a la semana pasada';
  }

  @override
  String comparisonVsLastMonth(String percent) {
    return '$percent% frente al mes pasado';
  }

  @override
  String get trendChartTitle => 'Tendencia diaria';

  @override
  String get trendChartAverageLabel => 'media';

  @override
  String get trendChartTrendLabel => 'tendencia';

  @override
  String get categoryChartTitle => 'Por categoría';

  @override
  String get categoryOther => 'Otros';

  @override
  String get equivalentToHeader => 'Equivale a';

  @override
  String get equivTreesLabel => 'árboles · año';

  @override
  String get equivCarKmLabel => 'km no recorridos';

  @override
  String get equivPhoneChargesLabel => 'cargas de móvil';

  @override
  String get equivBurgersLabel => 'hamburguesas de ternera';

  @override
  String get impactInfoTooltip => 'Cómo lo calculamos';

  @override
  String get impactInfoTitle => 'Cómo lo calculamos';

  @override
  String get impactInfoIntro =>
      'Convertimos el CO2 que has ahorrado en comparaciones cotidianas. Las cifras son orientativas: usamos medias mundiales y mezclamos CO2 con CO2 equivalente (metano, electricidad, ciclo de vida alimentario), así que tu impacto real depende de la red eléctrica local y la cadena de suministro.';

  @override
  String get impactInfoFormulaLabel => 'Fórmula';

  @override
  String get impactInfoSourceLabel => 'Fuente';

  @override
  String get equivTreesExplainer =>
      'CO2 aproximado que absorbe un árbol urbano maduro en un año. Los árboles recién plantados absorben mucho menos: esta cifra corresponde a árboles ya desarrollados.';

  @override
  String get equivCarKmExplainer =>
      'Emisiones medias de un coche por kilómetro recorrido, ponderadas entre gasolina y diésel.';

  @override
  String get equivPhoneChargesExplainer =>
      'Electricidad de red necesaria para cargar por completo un móvil medio, según el mix eléctrico nacional de EE. UU. Las redes más limpias (p. ej., Noruega) consumen menos; las más dependientes del carbón, más.';

  @override
  String get equivBurgersExplainer =>
      'Emisiones del ciclo de vida completo de una hamburguesa de ternera (113 g de carne), desde la ganadería hasta el comercio. Una hamburguesa de pollo emite unas 10 veces menos; una de alubias, unas 50 veces menos.';

  @override
  String equivFormulaTemplate(String factor) {
    return 'g de CO2 / $factor';
  }

  @override
  String get ecoDexTitle => 'Eco-Dex';

  @override
  String ecoDexProgress(int discovered, int total) {
    return '$discovered / $total descubiertos';
  }

  @override
  String get ecoDexLocked => 'Por descubrir';

  @override
  String get ecoDexViewSource => 'Ver fuente';

  @override
  String ecoDexAchievement(String hint) {
    return 'Logro: $hint';
  }

  @override
  String get ecoDexNewDiscovery => '¡Nuevo descubrimiento en el Eco-Dex!';

  @override
  String get ecoDexNextUp => 'Próximos';

  @override
  String get ecoDexDiscoveryTitle => '¡Logro desbloqueado!';

  @override
  String ecoDexEntryTitle(String name) {
    return 'Eco-Dex: $name';
  }

  @override
  String get ecoDexDiscoveryAcknowledge => '¡Genial!';

  @override
  String ecoDexDiscoveryMoreQueued(int count) {
    return '+$count más pendientes';
  }

  @override
  String get ecoDexEmptyHint =>
      'Registra tu primera acción para hacer tu primer descubrimiento.';

  @override
  String get ecoDexInfoTooltip => 'Acerca del Eco-Dex';

  @override
  String get ecoDexInfoTitle => 'Acerca del Eco-Dex';

  @override
  String get ecoDexInfoBody =>
      'El Eco-Dex es tu enciclopedia de datos sobre nuestro planeta. Las entradas se desbloquean automáticamente al usar Seed: registrar acciones, ahorrar CO2, mantener rachas, completar desafíos y leer eco-datos. Toca una tarjeta bloqueada para ver una pista sobre cómo descubrirla, y toca una entrada descubierta para leer su dato completo. Los descubrimientos no dan puntos: cada uno te recompensa con conocimiento.';

  @override
  String get transportCalculatorTitle => 'Transporte';

  @override
  String get calculatorsSheetTitle => 'Calculadoras';

  @override
  String get calculatorHomeEnergy => 'Energía del hogar';

  @override
  String get exploreTitle => 'Explorar';

  @override
  String get explorePlayHeader => 'Aprende y juega';

  @override
  String get exploreTransportSubtitle =>
      'Dos rutas, cualquier combinación de medios';

  @override
  String get exploreFoodSubtitle => 'Dos platos, ingrediente por ingrediente';

  @override
  String get exploreEnergySubtitle => 'Dos rutinas, de la ducha a la secadora';

  @override
  String get exploreEnergyRankedSubtitle =>
      'Hábitos cotidianos ordenados por energía';

  @override
  String get exploreQuizSubtitle => '¿Cuál emite más CO2?';

  @override
  String get mascotLinkTitle => 'Tu mascota';

  @override
  String get transportJourneyEmpty =>
      'Añade un tramo para crear tu trayecto y ver su huella de CO2e.';

  @override
  String get transportAddLeg => 'Añadir tramo';

  @override
  String get transportEditLeg => 'Editar tramo';

  @override
  String get transportSelectMode => 'Elige un medio de transporte';

  @override
  String get transportChangeMode => 'Cambiar';

  @override
  String get transportDistanceLabel => 'Distancia (km)';

  @override
  String get transportDistanceInvalid =>
      'Introduce una distancia de 0 km o más';

  @override
  String get transportDistanceEstimateNote =>
      'Estimación a partir de la ubicación de las ciudades. Ajústala a tu ruta.';

  @override
  String get transportDistanceUnknown => 'Desconocida';

  @override
  String transportFlightBandNote(String band) {
    return 'Esta distancia usa el factor de $band, para que un trayecto corto nunca se calcule como un vuelo de larga distancia.';
  }

  @override
  String get transportOccupantsLabel => 'Personas en el vehículo';

  @override
  String get transportOccupantsAdd => 'Añadir una persona';

  @override
  String get transportOccupantsRemove => 'Quitar una persona';

  @override
  String transportOccupantsSemantic(int count) {
    return 'Personas en el vehículo: $count';
  }

  @override
  String get transportTotalLabel => 'Total';

  @override
  String get transportRemoveLeg => 'Eliminar tramo';

  @override
  String get transportFromCity => 'Ciudad de origen';

  @override
  String get transportToCity => 'Ciudad de destino';

  @override
  String get transportCityPrefillHint =>
      'Elige dos ciudades para estimar las distancias.';

  @override
  String transportEstimatedKm(String km) {
    return '~$km km';
  }

  @override
  String transportKmValue(String km) {
    return '$km km';
  }

  @override
  String transportOccupantsValue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count personas',
      one: '1 persona',
    );
    return '$_temp0';
  }

  @override
  String transportModeFactorPerPassenger(int grams) {
    return '$grams g CO2e por km';
  }

  @override
  String transportModeFactorPerVehicle(int grams) {
    return '$grams g CO2e por vehículo y km';
  }

  @override
  String get transportGroupActive => 'A pie y en bici';

  @override
  String get transportGroupMicro => 'Micromovilidad';

  @override
  String get transportGroupCar => 'Coche y moto';

  @override
  String get transportGroupBus => 'Autobús y autocar';

  @override
  String get transportGroupTaxi => 'Taxi';

  @override
  String get transportGroupRail => 'Tren';

  @override
  String get transportGroupWater => 'Barco';

  @override
  String get transportGroupAir => 'Avión';

  @override
  String get transportGroupHighImpact => 'Alto impacto';

  @override
  String get transportModeScienceTooltip => 'Acerca de este factor';

  @override
  String get transportBasisEvGrid =>
      'Red eléctrica media mundial; varía según tu electricidad';

  @override
  String get transportBasisJetRf =>
      'Incluye el mismo recargo por gran altitud (forzamiento radiativo) que los vuelos';

  @override
  String get transportBasisZeroDirect => '0 emisiones directas';

  @override
  String get transportBasisElectricityOnly => 'Solo electricidad';

  @override
  String get transportComparisonTitle => 'Comparar trayectos';

  @override
  String get transportAddToComparison => 'Añadir como opción';

  @override
  String get calculatorStagedOptions => 'Opciones a comparar';

  @override
  String get calculatorRemoveOption => 'Quitar esta opción';

  @override
  String calculatorEntryPreview(String amount) {
    return 'Esto añade $amount CO2e';
  }

  @override
  String get co2eDefinitionTitle => '¿Qué es el CO2e?';

  @override
  String get co2eDefinitionBody =>
      'El CO2e cuenta el metano y otros gases de efecto invernadero como su equivalente en CO2, para que una hamburguesa y un vuelo se comparen en igualdad de condiciones.';

  @override
  String get calculatorOptionA => 'Opción A';

  @override
  String get calculatorOptionB => 'Opción B';

  @override
  String get calculatorDropHint =>
      'Arrastra o toca un elemento de abajo para añadirlo';

  @override
  String get calculatorAddToA => 'Añadir a A';

  @override
  String get calculatorAddToB => 'Añadir a B';

  @override
  String get calculatorBrowseAll => 'Ver todo';

  @override
  String get transportColumnEmptyHint =>
      'Toca «Añadir tramo» para empezar este trayecto';

  @override
  String get calculatorNeedBothOptions =>
      'Crea ambas opciones para compararlas';

  @override
  String get calculatorRemoveEntry => 'Quitar';

  @override
  String get scienceNotesHeading => 'Cómo se calcula';

  @override
  String get scienceSourcesHeading => 'Fuentes';

  @override
  String scienceAccessed(String date) {
    return 'Consultado el $date';
  }

  @override
  String transportComparisonFull(int max) {
    return 'Comparación completa ($max opciones)';
  }

  @override
  String transportCompareOptions(int count) {
    return 'Comparar $count opciones';
  }

  @override
  String transportOptionStaged(int count) {
    return 'Opción $count añadida';
  }

  @override
  String transportComparisonDelta(
    String label,
    String amount,
    String worse,
    int percent,
  ) {
    return '$label emite $amount CO2e menos que $worse ($percent% menos)';
  }

  @override
  String transportComparisonTreesEquiv(String count) {
    return 'Equivale a unos $count árboles absorbiendo CO2 durante un año';
  }

  @override
  String get transportMethodologyTitle => 'Metodología y fuentes';

  @override
  String transportMethodologyBody(int grid) {
    return 'Cada cifra de esta herramienta es una estimación con fines educativos, trazable a las fuentes indicadas abajo.\n\n### Qué se cuenta\nSolo la energía operativa: el combustible que queman los motores y la electricidad generada para los medios eléctricos. Se excluyen la fabricación de vehículos y las infraestructuras. Caminar e ir en bici cuentan como cero por convención: las calorías que gastas quedan fuera, ya que no tienen por qué añadirse a una dieta normal.\n\n### Ocupación\nLos coches y taxis se miden por vehículo, así que su huella se divide entre las personas a bordo. Autobuses, trenes y vuelos ya se miden por pasajero, con una ocupación típica.\n\n### Vuelos y forzamiento radiativo\nLos aviones calientan el clima más allá de su CO2 mediante estelas y efectos de gran altitud. Según DESNZ 2025, los factores de vuelos y jets privados incluyen un recargo de 1,7 (estimación central) sobre el componente de CO2. Los jets privados llevan el mismo recargo, así que se comparan en igualdad de condiciones.\n\n### Medios eléctricos y la red\nLos coches eléctricos, las bicis y los patinetes eléctricos no emiten nada por el tubo de escape; su huella proviene de generar la electricidad. Esta herramienta usa una red media mundial de $grid g CO2e por kWh, que varía mucho según el país y la hora, así que tu cifra real puede ser mayor o menor.\n\n### Medias, no tu trayecto exacto\nLos factores son medias por categoría, no tu vehículo, ruta o estilo de conducción concretos. Úsalos para comparar opciones, no para una contabilidad precisa del carbono.\n\n### Diferencias mínimas\nAlgunos medios están muy cerca: el autocar y el tren, por ejemplo, están a pocos gramos y su orden puede cambiar entre revisiones anuales de factores. Trata las diferencias pequeñas como un empate, no como un ganador claro.';
  }

  @override
  String get transportLogChoiceTitle => '¿Eliges la opción más ecológica?';

  @override
  String transportLogChoiceBody(String amount) {
    return 'Registra esto como una acción de transporte y acumula los $amount CO2e que evitas al elegir la opción de menor huella.';
  }

  @override
  String transportLogChoiceCta(String label) {
    return 'Registrar $label como mi elección de hoy';
  }

  @override
  String transportChoiceLoggedMessage(String amount) {
    return 'Registrado. Has acumulado $amount CO2e.';
  }

  @override
  String transportCustomActionName(String greener, String worse) {
    return 'Elegí $greener en vez de $worse';
  }

  @override
  String get transportChoseLabel => 'Elegí';

  @override
  String get transportInsteadOfLabel => 'en lugar de';

  @override
  String get transportChoiceDistinctHint =>
      'Elige dos opciones distintas para registrar tu elección.';

  @override
  String get transportActionsEntryTitle =>
      'Registrar una acción de transporte personalizada';

  @override
  String get customActionBadge => 'Personalizada';

  @override
  String get actionReproduce => 'Repetir';

  @override
  String get actionReproducedMessage => 'Registrado de nuevo';

  @override
  String get foodCalculatorTitle => 'Alimentación';

  @override
  String get foodMethodologyTitle => 'Metodología y fuentes';

  @override
  String get foodTotalLabel => 'Total';

  @override
  String get foodMealEmpty =>
      'Añade un ingrediente para crear tu comida y ver su huella de CO2e.';

  @override
  String get foodAddIngredient => 'Añadir';

  @override
  String get foodEditIngredient => 'Editar ingrediente';

  @override
  String get foodSelectItem => 'Elige un alimento';

  @override
  String get foodChangeItem => 'Cambiar';

  @override
  String get foodQuantityLabel => 'Cantidad (g)';

  @override
  String get foodQuantityInvalid => 'Introduce una cantidad de 0 g o más';

  @override
  String get quantityAmbiguousSeparator =>
      'Escribe los miles sin separador (1500). Para los decimales, sirven tanto 1,5 como 1.5.';

  @override
  String foodGramsValue(String grams) {
    return '$grams g';
  }

  @override
  String get foodRemoveIngredient => 'Eliminar ingrediente';

  @override
  String get foodItemScienceTooltip => 'Acerca de este factor';

  @override
  String get foodColumnEmptyHint => 'Toca «Añadir» para empezar esta comida';

  @override
  String get foodSearchHint => 'Buscar alimentos...';

  @override
  String get foodSearchNoResults => 'Ningún alimento coincide con la búsqueda.';

  @override
  String foodItemFactorWithServing(
    String perKg,
    String perServing,
    String serving,
  ) {
    return '$perKg kg CO2e por kg  ·  $perServing por $serving';
  }

  @override
  String foodItemFactorPerKg(String value) {
    return '$value kg CO2e por kg';
  }

  @override
  String get foodGroupMeat => 'Carne';

  @override
  String get foodGroupSeafood => 'Pescado y marisco';

  @override
  String get foodGroupDairyEggs => 'Lácteos y huevos';

  @override
  String get foodGroupPlantProtein => 'Proteína vegetal';

  @override
  String get foodGroupStaples => 'Alimentos básicos';

  @override
  String get foodGroupVegetables => 'Verduras';

  @override
  String get foodGroupFruit => 'Fruta';

  @override
  String get foodGroupDrinks => 'Bebidas';

  @override
  String get foodGroupTreats => 'Caprichos';

  @override
  String get foodGroupOils => 'Aceites';

  @override
  String get foodAddToComparison => 'Añadir como opción';

  @override
  String foodComparisonFull(int max) {
    return 'Comparación completa ($max opciones)';
  }

  @override
  String foodCompareOptions(int count) {
    return 'Comparar $count opciones';
  }

  @override
  String foodOptionStaged(int count) {
    return 'Opción $count añadida';
  }

  @override
  String get foodComparisonTitle => 'Comparar comidas';

  @override
  String get foodGroupNutsSeeds => 'Frutos secos y semillas';

  @override
  String get foodGroupCondiments => 'Condimentos';

  @override
  String get foodGroupPrepared => 'Platos preparados';

  @override
  String get foodBasisDry =>
      'Peso en seco: pésalo antes de cocinarlo o ponerlo a remojo.';

  @override
  String get foodBasisDrained =>
      'Peso escurrido: pésalo después de escurrir la lata.';

  @override
  String get foodBasisEdible =>
      'Peso comestible: pésalo sin cáscara, hueso ni piel.';

  @override
  String get foodBasisConcentrate =>
      'Peso sin diluir: pesa el concentrado, no la bebida.';

  @override
  String get foodBoundaryNarrower =>
      'Se ha medido sobre una cadena de suministro más corta que la mayoría de los alimentos de aquí, así que su cifra sale más baja en comparación.';

  @override
  String get foodPickerRecents => 'Recientes';

  @override
  String get foodVerdictWhyCta => '¿Por qué no hay resultado?';

  @override
  String get foodVerdictBlockedTitle =>
      'La diferencia no basta para registrarla';

  @override
  String foodVerdictTooClose(int percent) {
    return 'Estas dos comidas están a menos del $percent% una de otra. La mayoría de los alimentos de aquí comparten una media con toda una categoría, y muchos están empatados estadísticamente, así que una diferencia tan pequeña queda dentro de lo que la investigación de origen puede distinguir. Arriba tienes ambos totales; simplemente no declaramos una ganadora.';
  }

  @override
  String foodVerdictCrossSource(int percent) {
    return 'Estas comidas se miden con estudios distintos, y uno de ellos abarca una cadena de suministro más corta. Parte de cualquier diferencia podría deberse a eso y no a algo real, así que necesitaríamos que una emitiera menos de la mitad que la otra (en torno al $percent%) antes de decir cuál es mejor.';
  }

  @override
  String foodVerdictTiedBasis(int percent) {
    return 'Esta diferencia se apoya en ingredientes que comparten una misma cifra de investigación de origen. Cuando dos de ellos no coinciden, esa discrepancia es una decisión contable del estudio original y no algo medido en el campo. Si se deja eso a un lado, estas comidas quedan a menos del $percent% una de otra, así que no declaramos una ganadora. Arriba tienes ambos totales.';
  }

  @override
  String get foodVerdictTiedBasisFlips =>
      'Cuál de estas comidas sale mejor parada depende de una decisión contable del estudio original y no de los alimentos. Algunos ingredientes de ambos lados comparten una misma cifra de investigación de origen, y al fijar esa cifra en un único valor el resultado se invierte. Una ganadora que cambia así es un dato sobre el estudio, así que no declaramos ninguna. Arriba tienes ambos totales.';

  @override
  String foodVerdictUncertainItem(String item, String ratio, int percent) {
    return 'El problema es $item, no tus comidas. La investigación que hay detrás no se pone de acuerdo consigo misma: una minoría de productores de impacto muy alto eleva su media hasta $ratio veces su valor intermedio, así que dónde acaba depende mucho de qué granjas se cuenten. Una diferencia de en torno al $percent% superaría esa incertidumbre; esta no llega. Puedes registrar la comida como una acción normal.';
  }

  @override
  String get foodComparisonTooClose =>
      'Estas dos opciones están demasiado igualadas. Por debajo de un 20% de diferencia, la distancia entre ambas queda dentro de lo que la investigación de origen puede distinguir, así que mostramos ambos totales sin elegir una ganadora.';

  @override
  String foodComparisonDelta(
    String label,
    String amount,
    String worse,
    int percent,
  ) {
    return '$label emite $amount CO2e menos que $worse ($percent% menos)';
  }

  @override
  String foodComparisonCarKmEquiv(int km) {
    return 'Equivale a unos $km km no recorridos en un coche de gasolina';
  }

  @override
  String get foodChoseLabel => 'Comí';

  @override
  String get foodInsteadOfLabel => 'en lugar de';

  @override
  String foodLogChoiceBody(String amount) {
    return 'Registra esto como una acción de alimentación y acumula los $amount CO2e que evitas al elegir la comida de menor huella.';
  }

  @override
  String get foodChoiceDistinctHint =>
      'Elige dos comidas distintas para registrar tu elección.';

  @override
  String foodLogChoiceCta(String label) {
    return 'Registrar $label como mi elección de hoy';
  }

  @override
  String foodChoiceLoggedMessage(String amount) {
    return 'Registrado. Has acumulado $amount CO2e.';
  }

  @override
  String foodCustomActionName(String greener, String worse) {
    return 'Elegí $greener en vez de $worse';
  }

  @override
  String get foodActionsEntryTitle =>
      'Registrar una acción de alimentación personalizada';

  @override
  String get foodMethodologyBody =>
      'Cada cifra de esta herramienta es una estimación con fines educativos, trazable hasta las fuentes que se enumeran abajo.\n\n### Qué se cuenta\nCada factor abarca todo el ciclo de vida del alimento, de la cuna al comercio (cambio de uso del suelo, cultivo, pienso, procesado, transporte y envasado), según el metaanálisis de Poore & Nemecek de 2018 (unas 38.000 granjas), publicado por Our World in Data. Se excluyen la energía de cocinado en casa y el desperdicio alimentario doméstico. Es un alcance más amplio que el de la calculadora de transporte, que solo cuenta la energía operativa, así que nunca sumes cifras de las dos herramientas. Las cifras son las medias del estudio ponderadas por producción e incluyen las pérdidas de la cadena de suministro, no sus medianas, porque las medias representan mejor el impacto global total.\n\n### Una cifra, enorme dispersión\nEstas son medias globales por categoría. Un mismo alimento puede variar de 10 a 50 veces entre productores: la ternera va de unos 9 a 105 kg CO2e por 100 g de proteína, y el tomate de 0,45 kg CO2e/kg al aire libre y de temporada a 2,20 en invernadero con calefacción. Usa las cifras para comparar alimentos, no para juzgar una granja concreta.\n\n### Por qué no siempre declaramos una ganadora\nCada cifra de aquí es una media de miles de granjas, y esas granjas no se reparten de forma uniforme alrededor de ella. Una minoría de productores de impacto muy alto empuja la media por encima de lo que sería una granja típica, y por eso el estudio publica también un valor intermedio: la cifra que deja la mitad de la producción mundial a cada lado. En la mayoría de los alimentos ambos valores quedan cerca. En algunos no: el chocolate negro tiene una media de 46,65 kg CO2e/kg frente a un valor intermedio de 18,7, y el pescado de piscifactoría 13,63 frente a 5,1.\n\nUsamos las medias, porque representan el impacto mundial total y no la granja típica. La consecuencia es que dos alimentos con cifras próximas pueden intercambiar posiciones según cuál de los dos valores se mire. Por eso esta herramienta solo afirma que una comida es mejor que otra cuando la diferencia llega al 20%; por debajo de eso muestra ambos totales y te deja la comparación a ti.\n\nEse 20% está comprobado, no elegido por comodidad. En todas las parejas de alimentos de aquí para las que el estudio publica ambas cifras, una diferencia del 20% o más apunta en la misma dirección con cualquiera de las dos. Hay tres excepciones, porque su propia media y su valor intermedio difieren en más del doble: el chocolate negro, el pescado de piscifactoría y los frutos secos. En esos casos ninguna diferencia es fiable, así que nunca se usan para declarar una ganadora. Y cuando la comparación cruza dos estudios distintos (algunos alimentos de aquí se miden con una segunda fuente que abarca una cadena de suministro más corta), exigimos que una comida emita menos de la mitad que la otra, porque una diferencia menor podría ser solo el reflejo de lo que cada estudio contabilizó.\n\n### «Ecológico» y «local»\nAquí no hay descuento por ecológico ni por local, y es deliberado. El transporte suele ser menos del 10% de la huella de un alimento, así que la ternera local sigue teniendo una huella mucho mayor que las alubias importadas, y lo ecológico suele ser similar o mayor por kg. Lo que comes importa mucho más que lo lejos que haya viajado o cómo se haya producido.';

  @override
  String get energyGroupHotWater => 'Agua caliente';

  @override
  String get energyGroupDishes => 'Lavar platos';

  @override
  String get energyGroupLaundryWash => 'Lavado de ropa';

  @override
  String get energyGroupLaundryDry => 'Secado de ropa';

  @override
  String get energyGroupSpaceHeat => 'Calefacción';

  @override
  String get energyGroupSpaceCool => 'Refrigeración';

  @override
  String get energyGroupBoil => 'Hervir agua';

  @override
  String get energyGroupCook => 'Cocinar';

  @override
  String get energyGroupLighting => 'Iluminación';

  @override
  String get energyGroupDevice => 'Dispositivos';

  @override
  String get energyPickerRecents => 'Usados recientemente';

  @override
  String get energyBehaviorScienceTooltip => 'De dónde viene este número';

  @override
  String get energyLowConfidenceNote => 'La cifra menos fiable de estos datos';

  @override
  String energyFactorPerMinute(String kwh) {
    return '$kwh kWh por minuto';
  }

  @override
  String energyFactorPerHour(String kwh) {
    return '$kwh kWh por hora';
  }

  @override
  String energyFactorPerUse(String kwh) {
    return '$kwh kWh por uso';
  }

  @override
  String energyFactorPerDay(String kwh) {
    return '$kwh kWh por día';
  }

  @override
  String get energyQuantityOneMinute => '1 minuto';

  @override
  String get energyQuantityOneHour => '1 hora';

  @override
  String get energyQuantityOneDay => '1 día';

  @override
  String energyQuantityMinutes(String units) {
    return '$units minutos';
  }

  @override
  String energyQuantityHours(String units) {
    return '$units horas';
  }

  @override
  String energyQuantityUses(String units) {
    return '$units x';
  }

  @override
  String energyQuantityDays(String units) {
    return '$units días';
  }

  @override
  String get energyScienceNoSources =>
      'Esta cifra no lleva cita, a propósito. Las notas de arriba explican por qué.';

  @override
  String get energyCalculatorTitle => 'Energía del hogar';

  @override
  String get energyAddUsage => 'Añadir';

  @override
  String get energyColumnEmptyHint =>
      'Añade algo que hagas en casa para crear esta rutina';

  @override
  String get energyNoPointsNote =>
      'Esta calculadora es para aprender. No da puntos ni registra nada.';

  @override
  String get energyPresetsLabel => 'Cantidades habituales';

  @override
  String get energyQuantityLabel => 'Cantidad';

  @override
  String get energyQuantityInvalid => 'Introduce un número mayor que cero';

  @override
  String energyComparisonDelta(
    String label,
    String amount,
    String worse,
    int percent,
  ) {
    return '$label emite $amount CO2e menos que $worse ($percent% menos)';
  }

  @override
  String energyComparisonRatio(String worse, String multiple, String label) {
    return '$worse emite $multiple veces más CO2e que $label';
  }

  @override
  String energyComparisonSavesEquiv(String amount, int charges) {
    String _temp0 = intl.Intl.pluralLogic(
      charges,
      locale: localeName,
      other: '$charges cargas de móvil',
      one: 'una carga de móvil',
    );
    return 'Ahorras $amount, el equivalente en electricidad a $_temp0';
  }

  @override
  String energyComparisonSavesOnly(String amount) {
    return 'Ahorras $amount';
  }

  @override
  String energyPhoneChargesEquiv(int charges) {
    String _temp0 = intl.Intl.pluralLogic(
      charges,
      locale: localeName,
      other: 'unas $charges cargas de móvil',
      one: 'una carga de móvil',
    );
    return 'Equivale en electricidad a $_temp0';
  }

  @override
  String energyGridBasisNote(int grid) {
    return 'Las cifras en gramos suponen la red eléctrica media mundial, $grid g CO2e/kWh (Ember, datos de 2025)';
  }

  @override
  String energyGridBasisNoteRatio(int grid) {
    return 'Las cifras en gramos suponen la red eléctrica media mundial, $grid g CO2e/kWh (Ember, datos de 2025); el múltiplo se mantiene en cualquier red';
  }

  @override
  String get energyMethodologyTitle => 'Metodología y fuentes';

  @override
  String energyMethodologyBody(int grid) {
    return 'Todas las cifras de esta herramienta son estimaciones para aprender, trazables hasta las fuentes del final.\n\n### Qué se cuenta\nSolo energía operativa: la electricidad o el gas que tu hogar usa mientras haces la actividad. Coincide con el criterio de la calculadora de transporte y difiere a propósito del de la de comida, que cuenta un ciclo de vida completo: nunca sumes resultados de las tres herramientas. El gas cuenta solo la combustión; el término del pozo al tanque (aproximadamente un +17%) se excluye por coherencia con transporte. Aquí no se dan puntos: los hábitos de energía suman puntos en el registro de acciones.\n\n### ¿Por qué un único número para todo el mundo?\nLa electricidad no es igual de limpia en todas partes. La misma carga de secadora cuesta unos 0,6 kg CO2e en la red británica, 1,9 kg en Japón y 3,1 kg en la India: una diferencia de cinco veces para una acción idéntica. De dónde viene tu electricidad (solar, eólica y nuclear, o carbón) puede importar tanto como lo que hagas con ella.\n\nNos planteamos publicar un factor por país y decidimos no hacerlo. La precisión real exigiría tu país, tu región o compañía eléctrica (una sola media de EE. UU. esconde 26 subregiones) e incluso la hora del día, porque una red que funciona con energía solar a mediodía es mucho más limpia que la misma red en el pico de la tarde. Y todos esos números se mueven: el factor oficial del Reino Unido cayó un 26% en una sola revisión anual. Mantener cien cifras que caducan cada una a su ritmo es la mejor manera de equivocarse con confianza en cien sitios en vez de aproximar con honestidad en uno.\n\nAsí que hicimos tres cosas.\n\n**Una cifra global con fecha clara.** Usamos $grid g CO2e por kWh, la media mundial de 2025 publicada por Ember. Es demasiado alta para el Reino Unido o Francia y demasiado baja para la India o Polonia, y lo decimos.\n\n**Comparaciones válidas para todos.** Casi todas las comparaciones aquí son entre dos cosas que usan el mismo tipo de energía: un baño contra una ducha, una secadora contra un tendedero, un lavado caliente contra uno frío. Ahí el factor de red se cancela por completo: un baño cuesta 2,3 veces lo que una ducha de diez minutos en Glasgow, en Tokio o en Delhi. Los valores absolutos cambian con tu red; la comparación no.\n\n**Sin veredicto cuando tu red decide la respuesta.** Gas contra electricidad es la única comparación que de verdad se invierte. Por debajo de unos 241 g CO2e por kWh gana calentar agua con electricidad; por encima, gana el gas. El Reino Unido ya está por debajo de esa línea; Japón, muy por encima. Mostramos ambos números y no declaramos ganador, porque la respuesta honesta depende de dónde vives, no de lo que hayas hecho.\n\nPara comprobar tu propia red, compara el factor que publican tu compañía eléctrica o las estadísticas oficiales de energía con el $grid de arriba, y sabrás hacia dónde se inclinan estos números en tu caso.\n\n### Dónde está el calor\nTodo lo que genera o mueve calor (duchas, baños, secado, calefacción y aire acondicionado) cuesta entre 20 y 670 veces más que lo que solo produce luz o computación; la lista ordenada de abajo lo muestra. El ventilador es la excepción del grupo de refrigeración: mueve aire, no calor, por alrededor de una octava parte del consumo por hora de un aire acondicionado. Una nevera consume alrededor de 1 kWh al día, pero no puedes acortarla como acortas una ducha, así que no está en el selector; su etiqueta de eficiencia importa cuando la reemplazas.\n\nCuatro formas de calentar una habitación, sobre una misma base medida (METI), por hora:\n\n- Aire acondicionado (bomba de calor): 110 g CO2e\n- Estufa de gas: 181 g\n- Estufa de queroseno: 245 g\n- Calefactor eléctrico portátil (resistencia): 550 g\n\nUna bomba de calor emite unas 5 veces menos que un calefactor de resistencia, 1,6 veces menos que el gas y 2,2 veces menos que el queroseno. El queroseno gana a la resistencia eléctrica pero pierde con claridad frente a la bomba de calor: por eso las cuatro se muestran siempre juntas.\n\n### Medido, no nominal\nLas cifras del aire acondicionado son medias medidas de una hora de uso real (Energy Conservation Center vía METI); el valor de catálogo es unas 2,5 veces mayor porque se mide a plena carga. La del kotatsu es la medición media con termostato de los propios fabricantes: unas 8 veces menos que un calefactor portátil, y la cifra menos fiable de este conjunto de datos. Los ajustes de temperatura se limitan a ±2 °C: la regla práctica habitual dice un 13% (frío) / 10% (calor) por grado (Ministerio de Medio Ambiente de Japón), mientras que las mediciones de METI implican 15,2% / 12,6%; trata el ahorro por grado como aproximado, no lineal.\n\n### El standby, con honestidad\nEl consumo en espera por aparato cayó de 1-3 W a unos 0,5 W, pero el número de aparatos creció más deprisa: los hogares usan «aproximadamente la misma energía en espera, ahora repartida entre muchos más productos» (Lawrence Berkeley National Laboratory). El standby ni es trivial ni es el 10% de tu factura.\n\n### Iluminación\nLas cifras de apagar la luz parten de un LED de 8,5 W: unos 15 g por cuatro horas. Con una bombilla incandescente esas mismas cuatro horas son unos 110 g, y cambiar la bombilla ahorra mucho más que apagarla.\n\n### Emisiones evitadas\nLas acciones de segunda mano del registro de acciones (un coche usado, ropa de segunda mano, la biblioteca) premian la decisión de no comprar nuevo. Que dos personas se apunten la misma fabricación evitada es coherente; sumar esos créditos no lo es, porque la fabricación ocurrió una sola vez.';
  }

  @override
  String get energyRankedTitle => 'A dónde va tu energía';

  @override
  String get energyRankedIntro =>
      'Un uso típico de cada hábito, de mayor a menor, como múltiplo de la energía de una hora de luz LED. Cada fila indica su base (un uso, una hora o un día) debajo del nombre. Esto ordena la energía consumida, que es la parte que deciden tus hábitos.';

  @override
  String get energyRankedGasNote =>
      'Los aparatos de gas están en la misma lista, porque aquí se ordena por energía. Ojo a un detalle: un calentador de gas usa más energía que uno eléctrico para el mismo baño y, aun así, con la red media mundial de hoy emite menos. Por debajo de unos 241 g CO2e por kWh de electricidad, el resultado se invierte y gana la electricidad. La energía que usas es lo que eliges tú; lo limpia que sea la red depende de tu país y mejora cada año.';

  @override
  String energyRankedMultiple(String multiple) {
    return '${multiple}x';
  }

  @override
  String get energyComparisonNoVerdict => 'Aquí no hay ganador';

  @override
  String get energyVerdictDifferentGroup =>
      'Son dos cosas de distinto tipo, así que decir que una es mejor sería un error de categoría. Compara lo comparable: un baño con una ducha, una secadora con un tendedero.';

  @override
  String get energyVerdictDifferentCarrier =>
      'Una funciona con gas y la otra con electricidad, y cuál resulta más limpia depende de la red eléctrica de tu zona, no de lo que hayas hecho. Por debajo de unos 241 g CO2e por kWh gana la eléctrica; por encima, el gas. Por eso se muestran ambas cifras sin declarar un ganador.';

  @override
  String energyVerdictTooClose(int percent) {
    return 'La diferencia entre ambas es de menos del $percent%, dentro de la precisión de las mediciones de origen. Declarar un ganador sería atribuir una exactitud que las fuentes no tienen.';
  }

  @override
  String get energyUnitSuffixMinute => 'min';

  @override
  String get energyUnitSuffixHour => 'h';

  @override
  String get energyUnitSuffixUse => 'usos';

  @override
  String get energyUnitSuffixDay => 'días';

  @override
  String energyExploreIntro(String anchorUnit) {
    return 'Un uso típico de cada hábito, de mayor a menor, como múltiplo de la energía de $anchorUnit. Ordena la energía consumida, y los múltiplos se mantienen en cualquier red.';
  }

  @override
  String get energyExploreBarNote =>
      'Las barras usan una escala de raíz cuadrada para que las filas más pequeñas sigan visibles. Compara los números, no las barras.';

  @override
  String get energyAnchorChipLedBulb => 'LED 1 h';

  @override
  String get energyAnchorChipPhoneCharge => 'Móvil 1 carga';

  @override
  String get energyAnchorChipKettle => 'Hervidor 1 L';

  @override
  String get energyAnchorChipFan => 'Ventilador 1 h';

  @override
  String get energyAnchorUnitLedBulb => 'una hora de luz LED';

  @override
  String get energyAnchorUnitPhoneCharge => 'una carga completa de móvil';

  @override
  String get energyAnchorUnitKettle => 'un litro hervido en el hervidor';

  @override
  String get energyAnchorUnitFan => 'una hora de ventilador';

  @override
  String energyExploreSheetMultiple(String multiple, String anchorUnit) {
    return '${multiple}x $anchorUnit';
  }

  @override
  String energyExploreWallCaptionOne(String anchorUnit) {
    return 'Cada icono es $anchorUnit';
  }

  @override
  String get quizTitle => '¿Más o menos?';

  @override
  String get quizQuestion => 'Toca o arrastra hacia arriba la que emite más';

  @override
  String get quizSubtitle => '¿Cuál emite más CO2?';

  @override
  String get quizChooseHint => 'Elegir esta';

  @override
  String quizAnnounceRight(int count) {
    return '¡Correcto! Racha: $count';
  }

  @override
  String get quizAnnounceWrong => 'Esta vez no. Racha: 0';

  @override
  String quizItemLabel(String title, String subtitle) {
    return '$title, $subtitle';
  }

  @override
  String quizItemRevealedLabel(String title, String reveal) {
    return '$title: $reveal';
  }

  @override
  String quizItemInfoTooltip(String item) {
    return 'Acerca de «$item»';
  }

  @override
  String get quizItemInfoType => 'Tipo';

  @override
  String get quizItemInfoAmount => 'Cantidad comparada';

  @override
  String get quizItemInfoScience => 'De dónde viene este número';

  @override
  String get quizBasisEnergy => 'Energía del hogar: un uso típico';

  @override
  String get quizBasisFood => 'Comida: una ración';

  @override
  String get quizBasisTransport => 'Transporte: un pasajero-kilómetro';

  @override
  String get quizNoteFood =>
      'Las cifras de comida son medias de ciclo de vida de la cuna al comercio (Poore y Nemecek, 2018) por ración.';

  @override
  String get quizNoteTransport =>
      'Las cifras de transporte son por pasajero-kilómetro con ocupación media; caminar e ir en bici cuentan como cero.';

  @override
  String quizPerKm(String amount) {
    return '$amount por km';
  }

  @override
  String get quizFlightDomesticNote =>
      'Dentro de un país, unos 430 km de media';

  @override
  String get quizFlightShortHaulNote => 'Internacional, unos 1.500 km de media';

  @override
  String get quizFlightLongHaulNote => 'Intercontinental, 5.500 km o más';

  @override
  String get quizHigher => 'Más';

  @override
  String get quizLower => 'Menos';

  @override
  String get quizCorrect => '¡Correcto!';

  @override
  String get quizWrong => 'Esta vez no';

  @override
  String quizStreakLabel(int count) {
    return 'Racha: $count';
  }

  @override
  String quizBestLabel(int count) {
    return 'Mejor: $count';
  }

  @override
  String get quizContinue => 'Seguir';

  @override
  String get quizNewRun => 'Empezar de nuevo';

  @override
  String get quizLadderHeading => 'Tarjetas reveladas';

  @override
  String get quizNoPointsNote =>
      'Solo por diversión. No da puntos ni registra nada.';

  @override
  String get factPairsTitle => 'Parejas de datos';

  @override
  String get factPairsSubtitle => 'Une cada dato con su cifra';

  @override
  String get factPairsRules =>
      'Da la vuelta a dos cartas cada vez y encuentra la cifra de cada dato.';

  @override
  String factPairsFound(int found, int total) {
    return 'Parejas: $found de $total';
  }

  @override
  String factPairsMoves(int count) {
    return 'Movimientos: $count';
  }

  @override
  String get factPairsMatch => '¡Pareja!';

  @override
  String get factPairsMiss => 'No es pareja';

  @override
  String factPairsFinished(int moves) {
    String _temp0 = intl.Intl.pluralLogic(
      moves,
      locale: localeName,
      other: 'Todas las parejas en $moves movimientos',
      one: 'Todas las parejas en 1 movimiento',
    );
    return '$_temp0';
  }

  @override
  String factPairsCardHidden(int index, int total) {
    return 'Carta $index de $total, boca abajo';
  }

  @override
  String factPairsCardMatched(String text) {
    return '$text, emparejada';
  }

  @override
  String get factGamesPlayAgain => 'Jugar otra vez';

  @override
  String get factGamesLockedTitle => 'Descubre entradas del Eco-Dex para jugar';

  @override
  String factGamesLockedBody(int needed) {
    return 'Este juego se abre cuando descubras $needed entradas del Eco-Dex. Descúbrelas registrando acciones y completando desafíos; las que encuentres pueden aparecer aquí como preguntas.';
  }

  @override
  String factGamesLockedProgress(int count, int needed) {
    return '$count de $needed entradas del Eco-Dex descubiertas';
  }

  @override
  String get factGamesGoToEcoDex => 'Abrir el Eco-Dex';

  @override
  String get factRecallTitle => 'Recuerda la cifra';

  @override
  String get factRecallSubtitle => 'Completa la cifra de cada dato';

  @override
  String get factRecallRules => 'Elige la cifra que completa cada dato.';

  @override
  String factRecallProgress(int index, int total) {
    return 'Pregunta $index de $total';
  }

  @override
  String factRecallScore(int count) {
    return 'Aciertos: $count';
  }

  @override
  String get factRecallBlank => '____';

  @override
  String get factRecallBlankSpoken => 'espacio en blanco';

  @override
  String factRecallWrong(String figure) {
    return 'Esta vez no. Es $figure.';
  }

  @override
  String get factRecallExploreFact => 'Explorar este dato';

  @override
  String get factRecallNext => 'Siguiente pregunta';

  @override
  String get factRecallSeeScore => 'Ver resultado';

  @override
  String factRecallFinished(int correct, int total) {
    String _temp0 = intl.Intl.pluralLogic(
      correct,
      locale: localeName,
      other: '$correct aciertos de $total',
      one: '$correct acierto de $total',
    );
    return '$_temp0';
  }

  @override
  String get factRecallYourWrongAnswer => 'tu respuesta, incorrecta';

  @override
  String factRecallTimes(num count, String multiple) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$multiple veces',
      one: '$multiple vez',
    );
    return '$_temp0';
  }

  @override
  String factRecallBeefTofu(String figure) {
    return 'Por cada 100 g, la carne de vacuno genera cerca de $figure más CO2e que el tofu.';
  }

  @override
  String factRecallChickenBeans(String figure) {
    return 'Por cada 100 g, el pollo genera cerca de $figure más CO2e que las alubias y lentejas secas.';
  }

  @override
  String factRecallBeefChicken(String figure) {
    return 'Por cada 100 g, la carne de vacuno genera cerca de $figure más CO2e que el pollo.';
  }

  @override
  String factRecallMilkOat(String figure) {
    return 'Por cada 100 ml, la leche de vaca genera cerca de $figure más CO2e que la bebida de avena.';
  }

  @override
  String factRecallFlightShinkansen(String figure) {
    return 'Por pasajero y kilómetro, un vuelo nacional emite cerca de $figure más CO2e que el Shinkansen.';
  }

  @override
  String factRecallPrivateJet(String figure) {
    return 'Por pasajero y kilómetro, un jet privado emite cerca de $figure más CO2e que un vuelo de larga distancia en clase turista.';
  }

  @override
  String factRecallBulbs(String figure) {
    return 'Por hora, una bombilla incandescente emite cerca de $figure más CO2e que una bombilla LED.';
  }

  @override
  String factRecallShowers(String figure) {
    return 'Por minuto, una ducha con agua caliente eléctrica emite cerca de $figure más CO2e que una con bomba de calor.';
  }

  @override
  String factRecallWashes(String figure) {
    return 'Por colada, un lavado a 60 °C emite cerca de $figure más CO2e que uno a 20 °C.';
  }

  @override
  String factRecallCooling(String figure) {
    return 'Por hora, un aire acondicionado en modo refrigeración emite cerca de $figure más CO2e que un ventilador.';
  }

  @override
  String factRecallDishwasher(String figure) {
    return 'Por ciclo, el programa normal del lavavajillas emite cerca de un $figure más CO2e que el programa eco.';
  }

  @override
  String factRecallLambPork(String figure) {
    return 'Por cada 100 g, el cordero genera cerca de $figure más CO2e que el cerdo.';
  }

  @override
  String factRecallFerry(String figure) {
    return 'Por pasajero y kilómetro, quien viaja en ferri con coche emite cerca de $figure más CO2e que quien embarca a pie.';
  }

  @override
  String factRecallDryers(String figure) {
    return 'Por colada, una secadora con resistencia emite cerca de $figure más CO2e que una con bomba de calor.';
  }

  @override
  String factRecallCarCoach(String figure) {
    return 'Por pasajero y kilómetro, conducir sin acompañantes un coche de gasolina medio emite cerca de $figure más CO2e que un autocar de larga distancia.';
  }

  @override
  String factRecallCarBus(String figure) {
    return 'Por pasajero y kilómetro, conducir sin acompañantes un coche de gasolina medio emite cerca de un $figure más CO2e que un autobús urbano.';
  }

  @override
  String factRecallCarRail(String figure) {
    return 'Por pasajero y kilómetro, conducir sin acompañantes un coche de gasolina medio emite cerca de $figure más CO2e que el tren nacional o de cercanías.';
  }

  @override
  String walkthroughIntro1(String name) {
    return 'Hola, soy $name. Seed convierte las pequeñas decisiones de cada día en un hábito, y yo crezco contigo.';
  }

  @override
  String get walkthroughIntro2 =>
      'Aquí hay más de lo que parece. He hecho una lista de cosas por descubrir. Todo lo que brilla en dorado aún te espera.';

  @override
  String get walkthroughItemLogAction => 'Registra tu primera acción';

  @override
  String get walkthroughItemDailyChallenge => 'El desafío de hoy';

  @override
  String get walkthroughItemSdg => 'Descubre los ODS';

  @override
  String get walkthroughItemEcoFact => 'Tu eco-dato diario';

  @override
  String get walkthroughItemCalculators => 'Conoce las calculadoras';

  @override
  String get walkthroughItemQuiz => 'Juega a ¿Más o menos?';

  @override
  String get walkthroughItemProgress => 'Sigue tu progreso';

  @override
  String get walkthroughLogAction1 =>
      'Este es el corazón de Seed. Elige algo que hayas hecho hoy y yo contaré el carbono que has ahorrado.';

  @override
  String get walkthroughDailyChallenge1 =>
      'Un desafío nuevo cada día. Complétalo para desbloquear el eco-dato de hoy y mantener viva tu racha de desafíos.';

  @override
  String get walkthroughSdg1 =>
      'Los 17 ODS son la lista de tareas del mundo. Cada uno muestra sus metas, los avances hasta ahora y las acciones que ayudan.';

  @override
  String get walkthroughEcoFact1 =>
      'Cada día llega aquí un eco-dato nuevo. Completa el desafío de hoy para abrirlo.';

  @override
  String get walkthroughCalculators1 =>
      'Tres calculadoras comparan dos opciones. Transporte: dos rutas, cualquier combinación de medios. ¿Has elegido la más ecológica? Regístrala como acción.';

  @override
  String get walkthroughCalculators2 =>
      'Comida: dos platos, ingrediente por ingrediente. ¿Has elegido el más ligero? Regístralo también.';

  @override
  String get walkthroughCalculators3 =>
      'Energía del hogar: dos rutinas, de la ducha a la secadora. Enseña, pero nunca puntúa.';

  @override
  String get walkthroughCalculators4 =>
      'Debajo, «A dónde va tu energía»: hábitos cotidianos ordenados, medidos en horas de LED, cargas de móvil, litros de hervidor u horas de ventilador.';

  @override
  String get walkthroughQuiz1 =>
      'Dos cosas, una pregunta: ¿cuál emite más CO2? Encadena una racha. Sin puntos, solo para presumir.';

  @override
  String get walkthroughProgress1 =>
      'Calendario: cada día en que has registrado algo, y tu meta diaria.';

  @override
  String get walkthroughProgress2 =>
      'Impacto: el carbono que has ahorrado, convertido en árboles, kilómetros en coche, cargas de móvil y hamburguesas.';

  @override
  String get walkthroughProgress3 =>
      'Eco-Dex: datos del planeta que descubres al usar Seed. Cada uno es un pedacito de conocimiento, nunca puntos.';

  @override
  String get walkthroughComplete =>
      'Eso es todo. Ahora conoces Seed mejor que la mayoría. Algo nuevo te espera en el Eco-Dex. A crecer.';

  @override
  String get walkthroughChecklistTitle => 'Cosas por descubrir';

  @override
  String get walkthroughNext => 'Siguiente';

  @override
  String get walkthroughGotIt => 'Entendido';

  @override
  String get walkthroughStart => 'Vamos';

  @override
  String get settingsReplayWalkthrough => 'Repetir el recorrido';

  @override
  String get settingsReplayWalkthroughSubtitle =>
      'Deja que tu mascota te enseñe la app otra vez';

  @override
  String get settingsReplayWalkthroughConfirm =>
      '¿Repetir el recorrido? Todo volverá a brillar en dorado hasta que lo encuentres.';

  @override
  String get settingsReplayWalkthroughAction => 'Repetir';

  @override
  String get routeNotFound => 'No se ha encontrado esta página.';
}
