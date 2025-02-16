import React from 'react';
import Layout from '../components/layout/Layout';

const Home: React.FC = () => {
  return (
    <Layout>
      <div className="text-center">
        <h1 className="text-4xl font-bold mb-4">Welcome to Your App</h1>
        <p className="text-xl text-gray-600">
          This is a secure application built with Rails, React, and TypeScript.
        </p>
      </div>
    </Layout>
  );
};

export default Home; 