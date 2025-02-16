declare module '@hotwired/turbo-rails' {
  export const Turbo: {
    session: {
      drive: boolean;
    };
  };
}

// Declare process.env for development mode check
declare namespace NodeJS {
  interface ProcessEnv {
    NODE_ENV: 'development' | 'production' | 'test';
  }
} 