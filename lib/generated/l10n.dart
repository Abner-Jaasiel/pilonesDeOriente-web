// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `en`
  String get current_language {
    return Intl.message(
      'en',
      name: 'current_language',
      desc: '',
      args: [],
    );
  }

  /// `Select a language`
  String get selectALanguage {
    return Intl.message(
      'Select a language',
      name: 'selectALanguage',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message(
      'Search',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Loading`
  String get loading {
    return Intl.message(
      'Loading',
      name: 'loading',
      desc: '',
      args: [],
    );
  }

  /// `Log In`
  String get logIn {
    return Intl.message(
      'Log In',
      name: 'logIn',
      desc: '',
      args: [],
    );
  }

  /// `Create an account`
  String get createAnAccount {
    return Intl.message(
      'Create an account',
      name: 'createAnAccount',
      desc: '',
      args: [],
    );
  }

  /// `Account`
  String get account {
    return Intl.message(
      'Account',
      name: 'account',
      desc: '',
      args: [],
    );
  }

  /// `email`
  String get email {
    return Intl.message(
      'email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `password`
  String get password {
    return Intl.message(
      'password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register {
    return Intl.message(
      'Register',
      name: 'register',
      desc: '',
      args: [],
    );
  }

  /// `Alert`
  String get alert {
    return Intl.message(
      'Alert',
      name: 'alert',
      desc: '',
      args: [],
    );
  }

  /// `Empty`
  String get empty {
    return Intl.message(
      'Empty',
      name: 'empty',
      desc: '',
      args: [],
    );
  }

  /// `Empty field`
  String get emptyField {
    return Intl.message(
      'Empty field',
      name: 'emptyField',
      desc: '',
      args: [],
    );
  }

  /// `Check In`
  String get checkIn {
    return Intl.message(
      'Check In',
      name: 'checkIn',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Confirm password`
  String get confirmPassword {
    return Intl.message(
      'Confirm password',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Accept terms and conditions`
  String get acceptTermsAndConditions {
    return Intl.message(
      'Accept terms and conditions',
      name: 'acceptTermsAndConditions',
      desc: '',
      args: [],
    );
  }

  /// `Password is incorrect`
  String get passwordIsIncorrect {
    return Intl.message(
      'Password is incorrect',
      name: 'passwordIsIncorrect',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred during login`
  String get anErrorOccurredDuringLogin {
    return Intl.message(
      'An error occurred during login',
      name: 'anErrorOccurredDuringLogin',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get error {
    return Intl.message(
      'Error',
      name: 'error',
      desc: '',
      args: [],
    );
  }

  /// `Add To Cart`
  String get addToCart {
    return Intl.message(
      'Add To Cart',
      name: 'addToCart',
      desc: '',
      args: [],
    );
  }

  /// `Product added to cart`
  String get productAddedToCart {
    return Intl.message(
      'Product added to cart',
      name: 'productAddedToCart',
      desc: '',
      args: [],
    );
  }

  /// `Product removed from cart`
  String get productRemovedFromCart {
    return Intl.message(
      'Product removed from cart',
      name: 'productRemovedFromCart',
      desc: '',
      args: [],
    );
  }

  /// `View Cart`
  String get viewCart {
    return Intl.message(
      'View Cart',
      name: 'viewCart',
      desc: '',
      args: [],
    );
  }

  /// `See more`
  String get seeMore {
    return Intl.message(
      'See more',
      name: 'seeMore',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get close {
    return Intl.message(
      'Close',
      name: 'close',
      desc: '',
      args: [],
    );
  }

  /// `Comments`
  String get comments {
    return Intl.message(
      'Comments',
      name: 'comments',
      desc: '',
      args: [],
    );
  }

  /// `Comment`
  String get comment {
    return Intl.message(
      'Comment',
      name: 'comment',
      desc: '',
      args: [],
    );
  }

  /// `Product Aggregator`
  String get productAggregator {
    return Intl.message(
      'Product Aggregator',
      name: 'productAggregator',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get description {
    return Intl.message(
      'Description',
      name: 'description',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get add {
    return Intl.message(
      'Add',
      name: 'add',
      desc: '',
      args: [],
    );
  }

  /// `Cart`
  String get cart {
    return Intl.message(
      'Cart',
      name: 'cart',
      desc: '',
      args: [],
    );
  }

  /// `Shopping Cart`
  String get shoppingCart {
    return Intl.message(
      'Shopping Cart',
      name: 'shoppingCart',
      desc: '',
      args: [],
    );
  }

  /// `No data`
  String get noData {
    return Intl.message(
      'No data',
      name: 'noData',
      desc: '',
      args: [],
    );
  }

  /// `Add a photo`
  String get addAPhoto {
    return Intl.message(
      'Add a photo',
      name: 'addAPhoto',
      desc: '',
      args: [],
    );
  }

  /// `Title`
  String get title {
    return Intl.message(
      'Title',
      name: 'title',
      desc: '',
      args: [],
    );
  }

  /// `Location`
  String get location {
    return Intl.message(
      'Location',
      name: 'location',
      desc: '',
      args: [],
    );
  }

  /// `Price`
  String get price {
    return Intl.message(
      'Price',
      name: 'price',
      desc: '',
      args: [],
    );
  }

  /// `Add Details`
  String get addDetails {
    return Intl.message(
      'Add Details',
      name: 'addDetails',
      desc: '',
      args: [],
    );
  }

  /// `About`
  String get about {
    return Intl.message(
      'About',
      name: 'about',
      desc: '',
      args: [],
    );
  }

  /// `About me`
  String get aboutMe {
    return Intl.message(
      'About me',
      name: 'aboutMe',
      desc: '',
      args: [],
    );
  }

  /// `Unverified User`
  String get unverifiedUser {
    return Intl.message(
      'Unverified User',
      name: 'unverifiedUser',
      desc: '',
      args: [],
    );
  }

  /// `Value`
  String get value {
    return Intl.message(
      'Value',
      name: 'value',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Refresh`
  String get refresh {
    return Intl.message(
      'Refresh',
      name: 'refresh',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message(
      'Next',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  /// `Previous`
  String get previous {
    return Intl.message(
      'Previous',
      name: 'previous',
      desc: '',
      args: [],
    );
  }

  /// `Hello`
  String get hello {
    return Intl.message(
      'Hello',
      name: 'hello',
      desc: '',
      args: [],
    );
  }

  /// `Welcome`
  String get welcome {
    return Intl.message(
      'Welcome',
      name: 'welcome',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message(
      'Edit',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `Your user is not authenticated`
  String get yourUserIsNotAuthenticated {
    return Intl.message(
      'Your user is not authenticated',
      name: 'yourUserIsNotAuthenticated',
      desc: '',
      args: [],
    );
  }

  /// `Your user is not verified`
  String get yourUserIsNotVerified {
    return Intl.message(
      'Your user is not verified',
      name: 'yourUserIsNotVerified',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout {
    return Intl.message(
      'Logout',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to log out?`
  String get areYouSureYouWantToLogOut {
    return Intl.message(
      'Are you sure you want to log out?',
      name: 'areYouSureYouWantToLogOut',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message(
      'Yes',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get no {
    return Intl.message(
      'No',
      name: 'no',
      desc: '',
      args: [],
    );
  }

  /// `Products of the category`
  String get productsOfTheCategory {
    return Intl.message(
      'Products of the category',
      name: 'productsOfTheCategory',
      desc: '',
      args: [],
    );
  }

  /// `What is the estimated delivery time?`
  String get faqDeliveryTime {
    return Intl.message(
      'What is the estimated delivery time?',
      name: 'faqDeliveryTime',
      desc: '',
      args: [],
    );
  }

  /// `The estimated delivery time is 3 to 5 business days.`
  String get faqDeliveryTimeAnswer {
    return Intl.message(
      'The estimated delivery time is 3 to 5 business days.',
      name: 'faqDeliveryTimeAnswer',
      desc: '',
      args: [],
    );
  }

  /// `Does this product include a warranty?`
  String get faqWarranty {
    return Intl.message(
      'Does this product include a warranty?',
      name: 'faqWarranty',
      desc: '',
      args: [],
    );
  }

  /// `Yes, this product includes a 12-month warranty against manufacturing defects.`
  String get faqWarrantyAnswer {
    return Intl.message(
      'Yes, this product includes a 12-month warranty against manufacturing defects.',
      name: 'faqWarrantyAnswer',
      desc: '',
      args: [],
    );
  }

  /// `What does the package include?`
  String get faqPackageContents {
    return Intl.message(
      'What does the package include?',
      name: 'faqPackageContents',
      desc: '',
      args: [],
    );
  }

  /// `The package includes the product, user manual, and basic accessories.`
  String get faqPackageContentsAnswer {
    return Intl.message(
      'The package includes the product, user manual, and basic accessories.',
      name: 'faqPackageContentsAnswer',
      desc: '',
      args: [],
    );
  }

  /// `Most common questions`
  String get mostCommonQuestions {
    return Intl.message(
      'Most common questions',
      name: 'mostCommonQuestions',
      desc: '',
      args: [],
    );
  }

  /// `Image viewer`
  String get imageViewer {
    return Intl.message(
      'Image viewer',
      name: 'imageViewer',
      desc: '',
      args: [],
    );
  }

  /// `My products`
  String get myProducts {
    return Intl.message(
      'My products',
      name: 'myProducts',
      desc: '',
      args: [],
    );
  }

  /// `User products`
  String get userProducts {
    return Intl.message(
      'User products',
      name: 'userProducts',
      desc: '',
      args: [],
    );
  }

  /// `Create Store`
  String get createStore {
    return Intl.message(
      'Create Store',
      name: 'createStore',
      desc: '',
      args: [],
    );
  }

  /// `Buy`
  String get buy {
    return Intl.message(
      'Buy',
      name: 'buy',
      desc: '',
      args: [],
    );
  }

  /// `Seller management`
  String get sellerManagement {
    return Intl.message(
      'Seller management',
      name: 'sellerManagement',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get setting {
    return Intl.message(
      'Settings',
      name: 'setting',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message(
      'Confirm',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }

  /// `Theme`
  String get theme {
    return Intl.message(
      'Theme',
      name: 'theme',
      desc: '',
      args: [],
    );
  }

  /// `Share`
  String get share {
    return Intl.message(
      'Share',
      name: 'share',
      desc: '',
      args: [],
    );
  }

  /// `Download the Notes Smart App`
  String get downloadtheNotesSmartApp {
    return Intl.message(
      'Download the Notes Smart App',
      name: 'downloadtheNotesSmartApp',
      desc: '',
      args: [],
    );
  }

  /// `Terms and Conditions`
  String get termsAndConditions {
    return Intl.message(
      'Terms and Conditions',
      name: 'termsAndConditions',
      desc: '',
      args: [],
    );
  }

  /// `Delete Account`
  String get deleteAccount {
    return Intl.message(
      'Delete Account',
      name: 'deleteAccount',
      desc: '',
      args: [],
    );
  }

  /// `Dark`
  String get darkTheme {
    return Intl.message(
      'Dark',
      name: 'darkTheme',
      desc: '',
      args: [],
    );
  }

  /// `Light`
  String get lightTheme {
    return Intl.message(
      'Light',
      name: 'lightTheme',
      desc: '',
      args: [],
    );
  }

  /// `Could not launch the provided URL.`
  String get errorLaunchingURL {
    return Intl.message(
      'Could not launch the provided URL.',
      name: 'errorLaunchingURL',
      desc: '',
      args: [],
    );
  }

  /// `https://www.ancikle.tech/apps/notessmart/doc/NotesSmart%20-%20Privacy%20Policy.html`
  String get privacyPolicyURL {
    return Intl.message(
      'https://www.ancikle.tech/apps/notessmart/doc/NotesSmart%20-%20Privacy%20Policy.html',
      name: 'privacyPolicyURL',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete your Carkett Account?`
  String get doYouWanttoDeleteYourNotesSmartAccount {
    return Intl.message(
      'Are you sure you want to delete your Carkett Account?',
      name: 'doYouWanttoDeleteYourNotesSmartAccount',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to delete the account?`
  String get doYouWantToDeleteTheAccount {
    return Intl.message(
      'Do you want to delete the account?',
      name: 'doYouWantToDeleteTheAccount',
      desc: '',
      args: [],
    );
  }

  /// `Profiles`
  String get profiles {
    return Intl.message(
      'Profiles',
      name: 'profiles',
      desc: '',
      args: [],
    );
  }

  String get signUp {
    return Intl.message(
      'Sign Up',
      name: 'signUp',
      desc: '',
      args: [],
    );
  }

  String get termsConditions {
    return Intl.message(
      'I accept the Terms and Conditions',
      name: 'termsConditions',
      desc: '',
      args: [],
    );
  }

  String get logInToContinue {
    return Intl.message(
      'Log in to continue',
      name: 'logInToContinue',
      desc: '',
      args: [],
    );
  }

  String get errorFillFields {
    return Intl.message(
      'Please fill in all fields',
      name: 'errorFillFields',
      desc: '',
      args: [],
    );
  }

  String get alreadyHaveAnAccount {
    return Intl.message(
      'Already have an account?',
      name: 'alreadyHaveAnAccount',
      desc: '',
      args: [],
    );
  }

  String get dontHaveAnAccount {
    return Intl.message(
      "Don't have an account?",
      name: 'dontHaveAnAccount',
      desc: '',
      args: [],
    );
  }

  String get welcomeToCarkett {
    return Intl.message(
      "Welcome to Carkett",
      name: 'welcomeToCarkett',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'de'),
      Locale.fromSubtags(languageCode: 'es'),
      Locale.fromSubtags(languageCode: 'fr'),
      Locale.fromSubtags(languageCode: 'it'),
      Locale.fromSubtags(languageCode: 'ru'),
      Locale.fromSubtags(languageCode: 'zh'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
