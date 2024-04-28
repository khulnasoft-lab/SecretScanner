/**
 * Creating a sidebar enables you to:
 - create an ordered group of docs
 - render a sidebar for each doc of that group
 - provide next/previous navigation

 The sidebars can be generated from the filesystem, or explicitly defined here.

 Create as many sidebars as you want.
 */

// @ts-check

/** @type {import('@docusaurus/plugin-content-docs').SidebarsConfig} */
const sidebars = {
  secretscanner: [
    {
      type: 'html',
      value: 'Khulnasoft SecretScanner',
      className: 'sidebar-title',
    },    
  
    "secretscanner/index",
    "secretscanner/quickstart",

    {
      type: 'category',
      label: 'Using SecretScanner',

      items: [
        'secretscanner/using/build',
        'secretscanner/using/scan',
        'secretscanner/using/standalone',
        'secretscanner/using/grpc',
      ]
    },

    {
      type: 'category',
      label: 'Configuration',
      items: [
        'secretscanner/configure/cli',
        'secretscanner/configure/output',
      ]
    },
  ],
};

module.exports = sidebars;
