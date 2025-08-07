
enum AppExceptionCode {
  CODE_000_ERROR_UNEXPECTED,
  CODE_001_CUSTOMER_LOCAL_NOT_FOUND,
  CODE_002_CUSTOMER_SERVER_NOT_FOUND,
  CODE_003_CUSTOMER_DATA_INVALID,
  CODE_004_PRODUCT_LOCAL_NOT_FOUND,
  CODE_005_PRODUCT_SERVER_NOT_FOUND,
  CODE_006_PRODUCT_DATA_INVALID,
  CODE_007_AUTH_INVALID_CREDENTIALS,   // credenciais incorretas (usuário ou senha)
  CODE_008_AUTH_ACCOUNT_LOCKED,        // conta bloqueada
  CODE_009_AUTH_ACCOUNT_INACTIVE,      // conta inativa
  CODE_010_AUTH_MFA_REQUIRED,          // é necessário MFA (autenticação de dois fatores)
  CODE_011_AUTH_MFA_FAILED,            // falha na validação do MFA
  CODE_012_AUTH_NETWORK_ERROR,         // erro de rede durante o login
  CODE_013_AUTH_TIMEOUT,               // tempo de resposta do servidor esgotado
  CODE_014_USER_NOT_FOUND
}



