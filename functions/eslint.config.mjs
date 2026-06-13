// @ts-check
import tseslint from 'typescript-eslint';

export default tseslint.config(
  {ignores: ['lib/', 'eslint.config.mjs', 'jest.config.js']},
  ...tseslint.configs.recommendedTypeChecked,
  {
    languageOptions: {
      parserOptions: {
        projectService: true,
        tsconfigRootDir: import.meta.dirname,
      },
    },
    rules: {
      'max-len': ['error', {code: 88, ignoreUrls: true}],
    },
  },
  {
    // Jest matchers (expect.objectContaining etc.) are typed `any`;
    // flagging every assertion as unsafe is pure noise in tests.
    files: ['src/__tests__/**'],
    rules: {
      '@typescript-eslint/no-unsafe-assignment': 'off',
    },
  },
);
