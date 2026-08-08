import * as React from 'react';

import Button from '@/components/Button';

import Github from '~/svg/github.svg';

export default function Layout({ children }: { children: React.ReactNode }) {
  const contributeButtonLabel = () => {
    return (
      <div className='flex items-center justify-center gap-1 px-4'>
        <Github />
        Contribute
      </div>
    );
  };
  return (
    <>
      <div className='layout flex h-16 items-center justify-between'>
        <a
          href='https://d2lang.com'
          className='ml-4 flex items-center gap-2 font-primary-bold text-lg text-steel-900 hover:text-blue-600'
          aria-label='D2 project'
        >
          <img src='/svg/d2.svg' alt='' className='h-8 w-8' />
          <span>D2</span>
        </a>
        <Button
          onClick={() =>
            window.open('https://github.com/d2lang/text-to-diagram-site', '_blank')
          }
          className='mr-4 h-8'
          isPrimaryOutline
          label={contributeButtonLabel()}
        />
      </div>
      <div className='h-[4px] w-screen bg-header-gradient' />
      {children}
    </>
  );
}
